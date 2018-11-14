import os, shutil
        
def delete_directory(dir):
    if os.path.exists(dir):
        shutil.rmtree(dir)
        
def make_directory(dir):
    if not os.path.exists(dir):
        os.makedirs(dir)

def make_video_dir(base_dir, video_file):
    video_output_folder = os.path.join(base_dir, video_file)
    makedir(video_output_folder)
    return(video_output_folder)

def get_unprocessed_videos(video_path):
    videos = []

    for dirpath, dirnames, filenames in os.walk(video_path):
        if not dirnames:
            for filename in filenames:
                video_path = dirpath + os.sep + filename
                videos.append(video_path)
    return videos

def get_video_results_filename(video_file):
    return (video_file + '-results.csv')