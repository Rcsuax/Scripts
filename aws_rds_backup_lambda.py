import boto3
import datetime

client = boto3.client('rds')


def get_production_rds_id():
    response = client.describe_db_instances(
        MaxRecords=100,
    )
    db_instances = response.get('DBInstances', None)
    db_id_list = []
    for instance in db_instances:
        _id = instance.get('DBInstanceIdentifier', None)
        if _id:
            db_id_list.append(_id)

    for instance_id in db_id_list:
        arn = 'arn:aws:rds:eu-west-1:960071236802:db:{}'.format(instance_id)
        tag_response = client.list_tags_for_resource(
            ResourceName=arn
        )

        tag_list = tag_response.get('TagList', None)

        if {'Key': 'environment', 'Value': 'production'} in tag_list:
            return instance_id


def clean_up_old_snapshots(prod_id):
    for snapshot in client.describe_db_snapshots(DBInstanceIdentifier=prod_id, MaxRecords=50)['DBSnapshots']:
        snapshot_type = snapshot.get('SnapshotType', None)

        if 'SnapshotCreateTime' in snapshot and snapshot_type == 'manual':
            create_ts = snapshot['SnapshotCreateTime'].replace(tzinfo=None)

            if create_ts < datetime.datetime.now() - datetime.timedelta(days=8):
                print("Deleting snapshot id: {0}".format(snapshot['DBSnapshotIdentifier']))
                client.delete_db_snapshot(
                    DBSnapshotIdentifier=snapshot['DBSnapshotIdentifier']
                )


def lambda_handler(event, context):
    prod_id = get_production_rds_id()

    client.create_db_snapshot(
        DBSnapshotIdentifier='Manual-Backup-{0}-{1}'.format(datetime.datetime.now().strftime("%y-%m-%d-%H"), prod_id),
        DBInstanceIdentifier=prod_id,
    )

    clean_up_old_snapshots(prod_id)
