FROM python

COPY /services/llm/huggingface/openAssist.py /

RUN python -m pip install gradio 

RUN python -m pip install transformers 

RUN python -m pip install tensorflow 

RUN python -m pip install torch

RUN chmod +x ./openAssist.py

ENTRYPOINT [ "python", "/openAssist.py" ]