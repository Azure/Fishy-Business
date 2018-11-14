# -*- coding: utf-8 -*-
import cv2, dotenv, logging, os, shutil
from pathlib import Path
from src import common

def main():
    logger = logging.getLogger(__name__)
    logger.info('Starting listing videos...')
    
    video_path = os.getenv("UNPROCESSED_VIDEO")
    
    unprocessed_videos = common.get_unprocessed_videos(video_path)
    
    logger.info('%s unprocessed video.' % len(unprocessed_videos))
    
    for video_path in unprocessed_videos:
        logger.info(video_path)
    
    logger.info('Completed listing videos.')

if __name__ == '__main__':
    log_fmt = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    logging.basicConfig(level=logging.DEBUG, format=log_fmt)

    dotenv_path = dotenv.find_dotenv()
    
    if os.path.isfile(dotenv_path):
        dotenv.load_dotenv(dotenv_path)

    main()