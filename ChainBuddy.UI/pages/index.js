// // pages/index.js
// import ChatBox from '../components/ChatBox';
// import styles from '../styles/ChatBox.module.css';

// const Home = () => {
//     return (
//         <div className={styles.container}>
//             <h1>Chatbot</h1>
//             <ChatBox />
//         </div>
//     );
// }

// export default Home;


// pages/index.js

import { useState } from 'react';
import * as fcl from "@onflow/fcl";

fcl.config()
  .put("accessNode.api", "https://testnet.onflow.org")
  .put("discovery.wallet", "https://flow-wallet-testnet.blocto.app/authn")
  // .put("accessNode.api", "https://mainnet.onflow.org")
  // .put("discovery.wallet", "https://flow-wallet.blocto.app/authn")

export default function Home() {
  const [user, setUser] = useState({ loggedIn: null });

  // Check the current user's authentication status when the component mounts
  fcl.currentUser.subscribe(setUser);

  const handleSignIn = async () => {
    await fcl.authenticate();
  };

  const handleSignOut = async () => {
    await fcl.unauthenticate();
  };

  return (
    <div>
      {user.loggedIn ? (
        <div>
          <p>Address: {user.addr ?? 'Not logged in'}</p>
          <button onClick={handleSignOut}>Sign Out</button>
        </div>
      ) : (
        <button onClick={handleSignIn}>Sign In with Blocto</button>
      )}
    </div>
  );
}
