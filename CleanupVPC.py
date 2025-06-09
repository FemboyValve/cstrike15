import os
import fnmatch
import shutil

# Patterns to match
file_patterns = ['*.vcxproj', '*.filters', '*.user', '*.vpc_crc', '*.vcproj', '*.sln']
dir_names_to_delete = ['_vpc_']

def delete_files(root_dir):
    for root, dirs, files in os.walk(root_dir):
        for pattern in file_patterns:
            for filename in fnmatch.filter(files, pattern):
                file_path = os.path.join(root, filename)
                try:
                    os.remove(file_path)
                    print(f"Deleted file: {file_path}")
                except Exception as e:
                    print(f"Error deleting file {file_path}: {e}")

def delete_dirs(root_dir):
    for root, dirs, _ in os.walk(root_dir):
        for dirname in dirs:
            if dirname in dir_names_to_delete:
                dir_path = os.path.join(root, dirname)
                try:
                    shutil.rmtree(dir_path)
                    print(f"Deleted directory: {dir_path}")
                except Exception as e:
                    print(f"Error deleting directory {dir_path}: {e}")

if __name__ == "__main__":
    start_path = os.getcwd()
    delete_files(start_path)
    delete_dirs(start_path)
