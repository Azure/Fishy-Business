import cv2, dotenv, glob, logging, os, requests
import numpy as np
import pandas as pd
from pathlib import Path
from shutil import copyfile
from src import common

def main():
    logger = logging.getLogger(__name__)
    logger.info('Starting analyzing frames...')

    computervision_url = os.getenv("COMPUTERVISION_URL")
    computervision_key = os.getenv("COMPUTERVISION_KEY")
    
    input_frames_path = os.getenv("EXTRACTED_FRAMES")
    size_left_edge = int(os.getenv("SIZE_LEFT_EDGE"))

    out_folder_name = 'proposed'
    
    for dirpath, dirnames, filenames in os.walk(input_frames_path):
        if not dirnames and out_folder_name not in dirpath:
            out_folder_path = os.path.join(dirpath, out_folder_name)
            common.make_directory(out_folder_path)
            analyse_frames(dirpath, out_folder_path, computervision_url, computervision_key, size_left_edge)

    logger.info('Completed analyzing frames.')

def analyse_frames(in_folder_path, out_folder_path, computervision_url, computervision_key, size_left_edge):
    logger = logging.getLogger(__name__)

    frames = []
    tags = []
    texts = []
    confidences = []
    frame_paths = []
    
    file_names = [file_name for file_name in os.listdir(in_folder_path) if os.path.isfile(os.path.join(in_folder_path, file_name))]
    
    for file_name in file_names:
        print(file_name)
        frame_path = os.path.join(in_folder_path, file_name)
        logger.info('Frame: %s' %(frame_path))

        head, video_name = os.path.split(in_folder_path)

        result = analyse_frame(frame_path, computervision_url, computervision_key)
        logger.info(result)

        if ('tags' in result):
            all_tags = [x['name'] for x in result['tags']]
            if ('description' in result
                and 'captions' in result['description'] 
                and len(result['description']['captions']) > 0):
                text = result['description']['captions'][0]['text']
                confidence = result['description']['captions'][0]['confidence']
            else:
                text = ''
                confidence = ''

            #TODO: Change to configuration...
            if 'fish' in all_tags:
                # TODO: Move to a module of pre-processing tasks...
                frame = cv2.imread(frame_path)
                resized_frame = resize_by_left_edge(frame, size_left_edge)

                out_frame_path = os.path.join(out_folder_path, file_name)
                cv2.imwrite(out_frame_path, resized_frame)

                frames.append(file_name)
                tags.append(' '.join(all_tags))
                texts.append(text)
                confidences.append(confidence)
                frame_paths.append(frame_path)
    
    df = pd.DataFrame({'Frame': frames, 'Tag': tags, 'Text': texts, 'Confidence': confidences, 'Path': frame_paths})
    
    csv_name = common.get_video_results_filename(video_name)
    df.to_csv(os.path.join(out_folder_path, csv_name))

def analyse_frame(frame_path, computervision_url, computervision_key):
    logger = logging.getLogger(__name__)
    logger.info('Analyzing image using Computer Vision API: %s' %(frame_path))

    api_url = computervision_url + "analyze"
    headers = {
        # Request headers
        'Content-Type': 'application/octet-stream',
        'Ocp-Apim-Subscription-Key': computervision_key,
    }
    params   = {'visualFeatures': 'Tags,Description'}
    
    with open(frame_path, 'rb') as f:
        img_data = f.read()
        
    response = requests.post(api_url, params=params, headers=headers, data=img_data)
    
    try:
          response.raise_for_status()
    except:
        print(response)
        print(response.json())
     
    analysis = response.json()
    
    return analysis

def resize_by_left_edge(image, size_left_edge):
    r = size_left_edge / image.shape[1]
    dim = (size_left_edge, int(image.shape[0] * r))
    return cv2.resize(image, dim, interpolation = cv2.INTER_AREA)

if __name__ == '__main__':
    log_fmt = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    logging.basicConfig(level=logging.DEBUG, format=log_fmt)

    dotenv_path = dotenv.find_dotenv()
    
    if os.path.isfile(dotenv_path):
        dotenv.load_dotenv(dotenv_path)

    main()