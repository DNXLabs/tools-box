import subprocess, os, time, sys
import glob
from multiprocessing import Pool

users = []
def restore(user):
    my_host_dest="my_database.ap-southeast-2.rds.amazonaws.com"
    db_admin="admin"
    db_user="%s" % user
    db_pass=" " #db_passw fill up this field
    args = "/usr/bin/mysql -h %s -u %s -p%s < /home/restore/%s.sql" % (my_host_dest,db_admin,db_pass,db_user)
    try:
        subprocess.call('%s' % args, stderr=subprocess.PIPE, shell=True)
    except Exception as error:
        print(error)
        sys.exit(1)

def list_dbs():
    dbs = glob.glob("/home/restore/*.sql")
    for d in dbs:
        db = d.split('.')[0].split('/')[4].split('_')[2]
        users.append(db)
    return users

def main():
    users = list_dbs()
    start = time.time()
    pool = Pool(20)
    pool.map(restore, users)
    print('Restore finished in %s seconds' % str(time.time() - start))

if __name__ == '__main__':
    main()