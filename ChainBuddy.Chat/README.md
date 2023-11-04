# Rasa Chatbot README

## Project Overview

This repository contains a chatbot powered by the Rasa framework. Rasa is an open-source natural language processing (NLP) framework for building conversational AI applications. This chatbot is designed to support with operations on the Flow blockchain.

## Getting Started

### Prerequisites

Before you get started, make sure you have the following installed:

- Python (3.6+)
- Rasa (3.0+)

### Usage

1. Train your Rasa model using your training data:

```bash
   rasa train
```

2. Start the Rasa server to interact with your chatbot:

```bash
   rasa run
```

3. Start the action server. This command will start the custom action server, enabling your chatbot to perform actions and handle external events.

```bash
   rasa run actions
```
