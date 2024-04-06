meta_prompt = """[INST] <image>\n You should describe the image and fill in the dictionary about it: 
            {\"weather\": \"\", 
             \"time_of_day\": \"\", 
             \"atmosphere": \"\",
             \"season\": \"\",
             \"number_of_people\": \"\",
             \"main_color\": \"\", 
             \"grayscale\": \"\",
             \"landmark\": \"\"}
             
             You MUST use one of the options for some keys: 
             weather: солнечно, дождь, гроза, снег, облачно, пасмурно
             time_of_day: утро, день, вечер, ночь
             season: зима, весна, лето, осень
             atmosphere: Романтичная, Официально-деловая, Радостная, Меланхоличная, Нейтральная
             main_color: Красный, Оранжевый, Желтый, Зеленый, Голубой, Синий, Фиолетовый, Белый, Черный, Серый, Розовый, Коричневый
            
             Here are some explanations of given keys:
             main_color - average color of the photo
             atmosphere - overall mood of image contents. For example if there are churches on the picture, atmosphere should be религизно (translates as religious),
             if image gives sad vibes - it should be грустно (translates as sad)
             number_of_people should be integer. If there are no people fill in 0.
             grayscale should be integer if image is black and white (grayscale) fill in 1, if it has other colors fill in 0
             
             There is also a translation for your better understanding:
             солнечно - sunny, дождь - rainy, гроза - thunder, снег - snowy, облачно - cloudy, пасмурно - dull,
             утро - morning, день - noon, вечер - evening, ночь - night,
             зима - winter, весна - spring, лето - summer, осень - autumn,
             Красный - red, Оранжевый - orange, Желтый - yellow, Зеленый - green,
             Голубой - light blue, Синий - blue, Фиолетовый - purple, Белый - white, Черный - black, 
             Серый - gray, Розовый - pink, Коричневый - brown

             For the atmosphere there is a table of russian, its translation in english and description separated by |
             атмосфера | atmosphere | The general mood or feeling evoked by a place or situation.
             Романтичная | Romantic | reflects feelings, love, dreams. It can contain elements of nature, flowers, soft light, romantic details such as candles or a heart.
             Официально-деловая | Officially-business | it has a serious, professional look. It includes formal items, costumes, clean and neat design without unnecessary decorations.
             Радостная | Joyful | conveys joy, smiles, and positive emotions. It can include bright colors, people in happy situations, lively and dynamic compositions.
             Меланхоличная | Melancholic | means sadness, sadness, longing. It contains dark shades, dimmed lights, lonely or pensive figures, landscapes that evoke a sense of loss.
             Нейтральная | Neutral |  devoid of pronounced emotions or moods. It usually has calm colors, minimalistic design, simple composition without obvious emotional aspects.

             If there is a landmark on the image fill in the landmark IN CORRECT AND SIMPLE RUSSIAN LANGUAGE, give ONLY ITS NAME.
             IF IT IS NOT A LANDMARK ANSWER \"None\" IT IS IMPORTANT. Example: Московский Кремль. 
             
             For other keys fill them IN CORRECT AND SIMPLE RUSSIAN LANGUAGE [/INST]"""

person_prompt = ('[INST] <image>\n What . Fill in the dictionary {"age": ""} with one word describing the age of the '
                 'person on the image from the given young, teenager, adult or pensioner [/INST]')

landmark_prompt = ("[INST] <image>\n If there is a landmark on the image, give ONLY ITS NAME. IF IT IS NOT A LANDMARK "
                   "ANSWER \"None\" IT IS IMPORTANT. Example: Moscow Kremlin. [/INST]")
