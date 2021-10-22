import smtplib, os
import json
from pathlib import Path
from frictionless import Package
from dotenv import load_dotenv
load_dotenv(dotenv_path=Path('.', '.env'))

def check_log_erros():
  if validate_erros_look_up():
    send_mail()
  else:
    print('Nenhum erro detectado durante carga')

def send_mail():
  sender_email = "etl.age7.ckan@gmail.com"
  receiver_email_1 = "gabriel.dornas@cge.mg.gov.br"
  receiver_email_2 = "gabrielbdornas@gmail.com"
  receiver_email_3 = "fjunior.alves.oliveira@gmail.com"
  message = "Problema com a carga. Check os logs"
  smtpserver = smtplib.SMTP("smtp.gmail.com", 587)
  smtpserver.ehlo()
  smtpserver.starttls()
  smtpserver.ehlo()
  smtpserver.login(sender_email, os.environ.get('MAIL_PASSWORD'))
  print("Login realizado com sucesso!")
  smtpserver.sendmail(sender_email, receiver_email_1, message)
  smtpserver.sendmail(sender_email, receiver_email_2, message)
  smtpserver.sendmail(sender_email, receiver_email_3, message)
  print("E-mail enviado com sucesso. Confira sua caixa de entrada")

def validate_erros_look_up():
  any_errors = False
  package = Package('datapackage.yaml')
  path = 'logs/validate/'
  for resource in package.resources:
    file = open(f'{path}{resource.name}.json', "r").read()
    validation = json.loads(file)
    if validation["valid"] == False:
      any_errors = True
  return any_errors

if __name__ == "__main__":
  check_log_erros()
