# -*- coding: utf-8 -*-
import cv2, dotenv, logging, os, shutil
from pathlib import Path
from src import common

def main():
    logger = logging.getLogger(__name__)
    logger.info('Starting extracting frames...')
    
    videos_path = os.getenv("UNPROCESSED_VIDEO")
    extracted_frames_path = os.getenv("EXTRACTED_FRAMES")
    export_ps = int(os.getenv("EXTRACT_PER_SECOND"))

    unprocessed_videos = common.get_unprocessed_videos(videos_path)

    for video_path in unprocessed_videos:
        head, video_name = os.path.split(video_path)
        head, trip_name = os.path.split(head)
        head, site_name = os.path.split(head)
        export_frames(video_path, site_name, trip_name, video_name, extracted_frames_path, export_ps)
        move_video(video_path)

    logger.info('Completed extracting frames.')

def export_frames(video_path, site_name, trip_name, video_name, out_folder_path, export_ps=2):
    """ Exports frames of a single video
    """
    logger = logging.getLogger(__name__)
    logger.info('Exporting frames from video %s to %s' % (video_path, out_folder_path))
    
    out_folder_path = os.path.join(out_folder_path, site_name, trip_name, video_name)
    
    common.delete_directory(out_folder_path)
    
    common.make_directory(out_folder_path)
    
    if not os.path.isfile(video_path):
        raise ValueError('Video file does not exist at %s'% (video_path))

    # Open video and read initially
    vidcap = cv2.VideoCapture(video_path)
    success, np_image = vidcap.read()
    
    # Number of frames to export per second
    fps = vidcap.get(cv2.CAP_PROP_FPS)
    fpsexport = fps * export_ps
    fpsexport = int(fpsexport)

    logger.info('Exporting frame every %s second/s' %(export_ps))
    
    count = 0
    success = True
    while success:
        if (count % fpsexport) == 0:
            video_file_name = os.path.basename(video_path)
            frame_path = os.path.join(out_folder_path, video_file_name + '_frame_%d.jpg' % count).replace('\\','/')
            logger.debug('Saving frame %s' % (frame_path)) 
            cv2.imwrite(frame_path, np_image) # Save as JPG
        success, np_image = vidcap.read()
        count += 1
        
    logger.info('Exporting finished.')

def move_video(in_video_path):
    head, tail = os.path.split(in_video_path.replace('unprocessed', 'processed'))
    common.make_directory(head)
    shutil.move(in_video_path, head)
    
if __name__ == '__main__':
    log_fmt = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    logging.basicConfig(level=logging.DEBUG, format=log_fmt)

    dotenv_path = dotenv.find_dotenv()
    
    if os.path.isfile(dotenv_path):
        dotenv.load_dotenv(dotenv_path)

    main()