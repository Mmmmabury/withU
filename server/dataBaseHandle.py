# encoding=utf-8
import pymysql

class dataBase:
    def databaseHandle(self, sql):
        try:
            connection = pymysql.connect(host='127.0.0.1',
                user='root',
                password='',
                db='withU',
                cursorclass=pymysql.cursors.DictCursor,
                charset='utf8')
            with connection.cursor() as cursor:
                print("#### sql in databaseHndle:" + sql)
                cursor.execute(sql)
                sqltype = sql.split(' ')[0]
                if sqltype == 'select':
                    result = cursor.fetchall()
                    for k in result[0]:
                        if result[0][k] is None:
                            result[0][k] = "NULL"
                else:
                    result = []
                connection.commit()
                return result
        except Exception as e:
            print("database handle wrong:" + str(e))
            raise
        finally:
            connection.close()
