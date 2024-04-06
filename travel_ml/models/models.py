import json
import warnings
import io

from PIL import Image

import stability_sdk.interfaces.gooseai.generation.generation_pb2 as generation

from models.prompts import meta_prompt, person_prompt, landmark_prompt

import torch
from abc import abstractmethod

import ruclip

imagenet_templates = [
    'a photo of {}',
    'a picture of {}',
    'a drawing of a {}.',
    'a photo of my {}.',
    'depiction of a {}'
]


class BaseClipEmbedder:
    def __init__(self, clip_model, preprocessor, device):
        self._clip = clip_model
        self._preprocessor = preprocessor
        self._device = device

    @abstractmethod
    @torch.no_grad()
    def get_image_embeddings(self, images):
        pass

    @abstractmethod
    @torch.no_grad()
    def get_text_embeddings(self, texts):
        pass


class HFClipEmbedder(BaseClipEmbedder):
    def __init__(self, clip_model, preprocessor, device):
        super().__init__(clip_model, preprocessor, device)
        self._clip.eval()
        self._clip.to(self._device)

    def _internal_text_embedder(self, texts):
        class_embeddings = self._preprocessor(text=texts,
                                              return_tensors='pt',
                                              padding=True).to(self._device)

        return self._clip.get_text_features(**class_embeddings).cpu().detach()

    @torch.no_grad()
    def get_text_embeddings(self, texts):
        zeroshot_weights = []
        for classname in texts:
            texts = [template.format(classname) for template in imagenet_templates]  # format with class
            class_embeddings = self._internal_text_embedder(texts)
            class_embedding = class_embeddings.mean(dim=0)
            zeroshot_weights.append(class_embedding)
        return torch.stack(zeroshot_weights, dim=1).T

    @torch.no_grad()
    def get_image_embeddings(self, images):
        inputs = self._preprocessor.image_processor(images,
                                                    data_format='channels_first',
                                                    return_tensors='pt',
                                                    do_normalize=True)
        for key in inputs:
            inputs[key] = inputs[key].to(self._device)

        return self._clip.get_image_features(**inputs).cpu().detach()

    @staticmethod
    def get_score(image, text):
        return image @ text.mean(0).T, image @ text.T


class RuClipEmbedder(BaseClipEmbedder):
    def __init__(self, clip_model, preprocessor, device):
        super().__init__(clip_model, preprocessor, device)
        self._predictor = ruclip.Predictor(self._clip,
                                           self._preprocessor,
                                           self._device,
                                           bs=8,
                                           templates=imagenet_templates, quiet=True)

    @torch.no_grad()
    def get_image_embeddings(self, images):
        return self._predictor.get_image_latents(images).cpu()

    @torch.no_grad()
    def get_text_embeddings(self, texts):
        return self._predictor.get_text_latents(texts).cpu()


class LLAVA:
    def __init__(self, model, processor):
        self.model = model
        self.processor = processor

    @staticmethod
    def _strip_prompt(model_answer):
        return model_answer.replace(
            model_answer[model_answer.find('[INST]'): model_answer.rfind('[/INST]') + len('[/INST]')], '').strip()

    @torch.no_grad()
    def _internal_input(self, image, prompt):
        inputs = self.processor(prompt, image, return_tensors="pt").to("cuda:0")
        output = self.model.generate(**inputs, max_new_tokens=200, pad_token_id=self.processor.tokenizer.eos_token_id)
        model_answer = self.processor.decode(output[0], skip_special_tokens=True)
        torch.cuda.empty_cache()
        return model_answer

    def describe_image(self, image):
        model_answer = self._internal_input(image, meta_prompt)
        return json.loads(self._strip_prompt(model_answer))

    def get_person_info(self, image):
        model_answer = self._internal_input(image, person_prompt)
        return json.loads(self._strip_prompt(model_answer))

    def get_landmark(self, image):
        return self._strip_prompt(self._internal_input(image, landmark_prompt))
