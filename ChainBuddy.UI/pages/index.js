// pages/index.js
import ChatBox from '../components/ChatBox';
import styles from '../styles/ChatBox.module.css';

const Home = () => {
    return (
        <div className={styles.container}>
            <h1>Chatbot</h1>
            <ChatBox />
        </div>
    );
}

export default Home;
