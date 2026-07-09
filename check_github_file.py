import base64
import json
import urllib.request

url = 'https://api.github.com/repos/mounifhaydar/devops-project-1/contents/Jenkinsfile?ref=main'
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req, timeout=20) as r:
    data = json.load(r)
    content = base64.b64decode(data['content']).decode()
    print(content)
