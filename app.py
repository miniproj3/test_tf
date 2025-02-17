import os
import json
import boto3
from flask import Flask, request
import pymysql

app = Flask(__name__)

# AWS Secrets Manager에서 비밀번호 가져오는 함수
def get_secret():
    secret_name = os.getenv('SECRET_NAME')  # Secret Manager에 저장된 Secret 이름
    region_name = os.getenv('AWS_REGION', 'ap-northest-2')  # 기본 리전 설정

    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager', region_name=region_name)

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
        secret = json.loads(get_secret_value_response['SecretString'])
        return secret.get('password')  # Secret 구조에서 password 값만 반환
    except Exception as e:
        print(f"Secrets Manager에서 비밀번호를 가져오는 중 오류 발생: {e}")
        return None

# 환경 변수에서 DB 연결 정보 가져오기
db_host = os.getenv('MYSQL_HOST')
db_port = int(os.getenv('MYSQL_PORT', 3306))
db_user = os.getenv('MYSQL_USER')
db_password = get_secret()  # AWS Secrets Manager에서 가져옴
db_name = os.getenv('MYSQL_DATABASE')

# MySQL 연결 함수
def connect_to_db():
    return pymysql.connect(
        host=db_host,
        port=db_port,
        user=db_user,
        password=db_password,
        database=db_name,
        cursorclass=pymysql.cursors.DictCursor,
    )

@app.route('/')
def index():
    return """
    <h1>상품 관리</h1>
    <form method="POST" action="/add">
        <label for="item">물건 이름:</label><br>
        <input type="text" id="item" name="item"><br>
        <label for="price">가격:</label><br>
        <input type="number" id="price" name="price"><br><br>
        <button type="submit">추가</button>
    </form>
    <br>
    <a href="/items">저장된 상품 보기</a>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
