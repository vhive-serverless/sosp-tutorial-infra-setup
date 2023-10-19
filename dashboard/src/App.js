import React, { useState } from 'react';
import './App.css'; // Import the CSS file for styling
import { FaCopy } from 'react-icons/fa';

const EmailForm = () => {
  const [email, setEmail] = useState('');
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleEmailChange = (e) => {
    setEmail(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await fetch(`https://ypsaexi7fntypjfdk7sdorcjuu0kcgru.lambda-url.us-east-1.on.aws/`, {
        method: 'GET',
        // Add any headers or other configurations as needed
      });
      console.log(response)
      if (response.ok) {
        const result = await response.json();
        setData(result);
      } else {
        // Handle API errors
      }
    } catch (error) {
      // Handle network errors
    }

    setLoading(false);
  };

  const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text);
  };
    
    return (
      <div className="card">
        <h2>The 2nd Tutorial on vHive & Serverless Research</h2>
        <div className="logo-container">
          <img src={"/sosp-tutorial-infra-setup/vhive-logo.png"}  alt="vHive Logo" width={'150px'}/>
          {/* <img src={"./vhive-logo.png"} alt="vHive Logo" width={'150px'}/> */}
        </div>
        {data ? (
    <div>
        <h3>SSH credentials for vHive:</h3>
        <div style={{ display: 'flex', alignItems: 'center' }}>
      <div className="response-box">
        <div>
          <pre class="response-text">{JSON.stringify(data.vhive, null, 2)}</pre>   
        </div>
        <pre class="response-text">password : vhive-sosp</pre>       
        </div>
          <button
                className="copy-button"
                onClick={() => copyToClipboard(JSON.stringify(data.vhive, null, 2))}
              >
           <FaCopy/>
          </button>
      </div>
      <h3 style={{marginTop:'20px'}}>SSH credentials for Invitro:</h3>
      <div style={{ display: 'flex', alignItems: 'center' }}>
      <div className="response-box">
       
        <div>
          <pre class="response-text">{JSON.stringify(data.invitro, null, 2)}</pre>
         <pre class="response-text">password :  invitro-sosp</pre>
        </div>
        
      </div>
      <button
            className="copy-button"
            onClick={() => copyToClipboard(JSON.stringify(data.invitro, null, 2))}
          >
           <FaCopy/>
          </button>
     </div>
      
    </div>
  ) : (
    <form onSubmit={handleSubmit}>
      <label>
        Email:
        <input type="email" value={email} onChange={handleEmailChange} />
      </label>
      <button type="submit" disabled={loading}>
        {loading ? 'Loading...' : 'Submit'}
      </button>
    </form>
  )}
</div>
    );
  };

export default EmailForm;
