from pydantic import BaseModel
from typing import Union, List, Dict, Any


class Image(BaseModel):
    filename: str
    label: Union[str, None] = None
    tags: Union[List['str'], None] = None
    time_of_day: Union[str, None] = None
    atmosphere: Union[str, None] = None
    weather: Union[str, None] = None
    season: Union[str, None] = None
    number_of_people: int = 0
    main_color: Union[str, None] = None
    grayscale: Union[bool, None] = False
    landmark: Union[str, None] = None
    orientation: Union[str, None] = None


class Filters(BaseModel):
    time_of_day: Union[List[str], None] = None
    atmosphere: Union[List[str], None] = None
    weather: Union[List[str], None] = None
    season: Union[List[str], None] = None
    number_of_people: Union[List[int], None] = None
    main_color: Union[List[str], None] = None
    tags: Union[List[str], None] = None
    orientation: Union[List[str], None] = None
