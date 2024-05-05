# import docker
# from flask import Flask, render_template

# app = Flask(__name__)
# client = docker.from_env()

# HOST_PREFIX = "http://192.168.3.201"

# def get_containers():
#     containers = client.containers.list()
#     return containers

# def get_open_ports(container):
#     ports = container.attrs['NetworkSettings']['Ports']
#     open_ports = []
#     for port in ports:
#         if ports[port] is not None:
#             open_ports.append(port)
#     return open_ports

# def generate_links(container):
#     links = []
#     open_ports = get_open_ports(container)
#     for port in open_ports:
#         print(port)
#         port_mapping = container.attrs['NetworkSettings']['Ports'][port][0]
#         host_port = port_mapping['HostPort']
#         service_link = f"{HOST_PREFIX}:{host_port}"
#         function_label = f"function.port.{port.split('/')[0]}"
#         function = container.labels.get(function_label, 'unknown')
#         links.append({'link': service_link, 'function': function})
#     return links

# @app.route('/')
# def index():
#     containers = get_containers()
#     container_data = []
#     for container in containers:
#         container_name = container.name
#         links = generate_links(container)
#         container_data.append({'name': container_name, 'links': links})
#     return render_template('index.html', container_data=container_data)

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5555)

from flask import Flask, render_template
import requests
import re

app = Flask(__name__)

TRAEFIK_API_URL = "http://192.168.3.201:9191/api/http/routers"

def get_services():
    try:
        response = requests.get(TRAEFIK_API_URL)
        print(response)
        if response.status_code == 200:
            data = response.json()
            services = []
            for d in data:
                print(d)
                # Regular expression pattern to extract domains within brackets or parentheses
                pattern = r'\b(?:[\w-]+\.)+[\w-]+(?:\/\S*)?'


                # Extract domains using regex
                domains = re.findall(pattern, d["rule"])
                print(domains)
                for domain in domains:
                    services.append(domain)
                # service_name = router_info.get("service")
                # print(service_name)
                # if service_name and service_name not in services:
                #     services.append(service_name)
            return services
    except Exception as e:
        print("Error:", e)
    return []

@app.route("/")
def index():
    services = get_services()
    return render_template("index.html", services=services)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5555)
