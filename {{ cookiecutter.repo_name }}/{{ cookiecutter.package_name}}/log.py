import logging
from pathlib import Path


def get_logger(log_pth: Path = None):
    handlers = [logging.StreamHandler()]
    if log_pth is not None:
        handlers.append(logging.FileHandler(log_pth))
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
        handlers=handlers,
        force=True)
    return logging.getLogger()
