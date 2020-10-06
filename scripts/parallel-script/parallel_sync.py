import subprocess, os, time, sys
import glob
from multiprocessing import Pool

files = []
def sync(file_name):
    orig_bucket="s3://my-origin-bucket"  # origin bucket
    dest_bucket="s3://my-destination-bucket" # destination bucket
    args = "aws s3 cp %s/%s %s/%s >> ./files_finished.txt" % (orig_bucket,file_name,dest_bucket,file_name)
    try:
        proc = subprocess.call('%s' % args,
                stderr=subprocess.PIPE, shell=True)
    except Exception as error:
        print error
        sys.exit(1)

def list_files():
    with open("my_files_list.txt", "r") as file_list:
        for f in file_list:
            files.append(f.replace('\n', ' ').replace('\r', ''))
        return files

def main():
    files = list_files()
    start = time.time()
    pool = Pool(15)
    pool.map(sync, files)
    print 'Sync finished in %s seconds' % str(time.time() - start)

if __name__ == '__main__':
    main()