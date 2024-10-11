from pathlib import Path

import yaml
from pydantic import BaseModel


class Config(BaseModel):
    pass


def load_config(config_pth: Path) -> Config:
    with open(config_pth, "r") as f:
        config = yaml.safe_load(f)
    return Config(**config)
