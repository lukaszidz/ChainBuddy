// components/ChatBox.js
import { useState } from 'react';

const ChatBox = () => {
    const [messages, setMessages] = useState([]);
    const [input, setInput] = useState('');

    const sendMessage = async () => {
        const userMessage = {
            role: 'user',
            text: input
        };

        // Add user message to chat window
        setMessages([...messages, userMessage]);

        // Fetch response from Rasa API
        const response = await fetch('http://localhost:5005/webhooks/rest/webhook', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                message: input,
                sender: 'user'
            })
        });

        const responseData = await response.json();
        const botMessages = responseData.map(msg => ({
            role: 'bot',
            text: msg.text
        }));

        // Add bot's responses to chat window
        setMessages(prevMessages => [...prevMessages, ...botMessages]);
        setInput('');  // Clear the input
    };

    return (
        <div className="chat-container">
            <div className="chat-window">
                {messages.map((message, index) => (
                    <div key={index} className={`message ${message.role}`}>
                        {message.text}
                    </div>
                ))}
            </div>
            <div className="input-container">
                <input
                    type="text"
                    value={input}
                    onChange={e => setInput(e.target.value)}
                    placeholder="Type your message..."
                />
                <button onClick={sendMessage}>Send</button>
            </div>
        </div>
    );
}

export default ChatBox;
