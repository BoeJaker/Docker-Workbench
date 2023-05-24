import gradio as gr
from transformers import pipeline, BertForQuestionAnswering, BertTokenizer
import time
import random
import wikipediaapi
import torch
import threading
import gradio as gr
import requests

lock = threading.Lock()

mode="bert"

if mode == "gpt":
    model_name = "gpt2"
    generator = pipeline("text-generation", model=model_name)
    generator.model.config.temperature = 0.6
    generator.model.config.repetition_penalty = 1.5
    generator.model.config.length_penalty = 2
    generator.model.config.max_length = 500
    model_info = generator.model.config
if mode == "bert":
    model_name = 'bert-large-uncased-whole-word-masking-finetuned-squad'
    tokenizer = BertTokenizer.from_pretrained(model_name)
    model = BertForQuestionAnswering.from_pretrained(model_name)
    # Example question
    question = "What is the capital of France?"

    # Fetch Wikipedia page
    wiki_wiki = wikipediaapi.Wikipedia('en')
    page = wiki_wiki.page("France")  # Replace "France" with the desired Wikipedia page title or search query

    # Extract the content from the Wikipedia page
    context = page.text

    # Split the long context into smaller segments using a sliding window approach
    max_segment_length = 512
    stride = 256
    segments = [context[i:i+max_segment_length] for i in range(0, len(context), stride)]

    # Initialize an empty list to store answers
    answers = ["",]
    stop = 0

def process_segment(question, segment):


    global stop
    # Tokenize inputs
    inputs = tokenizer.encode_plus(question, segment, add_special_tokens=True, return_tensors="pt")
    
    # Perform question-answering
    outputs = model(**inputs)
    start_scores = outputs.start_logits
    end_scores = outputs.end_logits
    
    # Get the most probable answer
    answer_start = torch.argmax(start_scores)
    answer_end = torch.argmax(end_scores) + 1
    answer = tokenizer.convert_tokens_to_string(tokenizer.convert_ids_to_tokens(inputs["input_ids"][0][answer_start:answer_end]))
    if answer:
        certainty_score = start_scores[0][answer_start].item() + end_scores[0][answer_end-1].item()

        print(certainty_score, answer)
        if certainty_score >= 7 :
            # Store the answer
            answers[0]=answer
            print(answer)
            stop = 1

def qa_bot(history):
    global stop
    question = history[-1][0]
    threads=[]
    # Iterate over each segment and perform question-answering
    for segment in segments:
        process_segment(question,segment)
        # Check if new threads should be generated
        # with lock:
        if stop == 1:
            stop = 0
            break

        # t = threading.Thread(target=process_segment,args=(question,segment))
        # threads.append(t)
        # t.start()
        
            

    # for t in threads:
    #     t.join() 

    # Combine answers from all segments
    combined_answer = ' '.join(answers)
    history[-1][1] = ""
    for character in combined_answer:
            history[-1][1] += character
            time.sleep(0.05)
            yield history

def add_text(history, text):
    history = history + [(text, None)]
    return history, ""

def add_file(history, file):
    history = history + [((file.name,), None)]
    return history

def bot(history):
    # Get the last user input from the history
    user_input = history[-1][0]

    # Generate a response using the Hugging Face model
    response = generator(user_input, do_sample=True)[0]["generated_text"]
    
    # history[-1][1] = response
    history[-1][1] = ""
    for character in response:
            history[-1][1] += character
            time.sleep(0.02)
            yield history

with gr.Blocks() as demo:
    gr.Markdown("""# """ + model_name.upper())
    chatbot = gr.Chatbot([], elem_id="chatbot").style(height=750)

    with gr.Row():
        with gr.Column(scale=0.85):
            txt = gr.Textbox(
                show_label=False,
                placeholder="Enter text and press enter, or upload an image",
            ).style(container=False)
        with gr.Column(scale=0.15, min_width=0):
            btn = gr.UploadButton("📁", file_types=["image", "video", "audio"])
    if mode == "gpt":
        txt.submit(add_text, [chatbot, txt], [chatbot, txt]).then(
            bot, chatbot, chatbot
        )
        btn.upload(add_file, [chatbot, btn], [chatbot]).then(
            bot, chatbot, chatbot
        )
    if mode == "bert":
        txt.submit(add_text, [chatbot, txt], [chatbot, txt]).then(
            qa_bot, chatbot, chatbot
        )
        btn.upload(add_file, [chatbot, btn], [chatbot]).then(
            qa_bot, chatbot, chatbot
        )
    try:
        gr.Markdown(
            """## Parameters\n<br><table><tr><th>Name</th><th>Value</th></tr>""" +
            "".join(f"<tr><td><b>{key}</b></td><td>{value}</td></tr>" for key, value in model_info.__dict__.items()) +
            """</table>"""
        )
    except:
        pass

demo.queue()
demo.launch(share=True)
