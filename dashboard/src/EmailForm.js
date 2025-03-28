
import React, { useState } from 'react';
import './App.css'; // Import the CSS file for styling
import { FaCopy } from 'react-icons/fa';


const EmailForm = () => {
  const [email, setEmail] = useState('');
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(false);

  const handleEmailChange = (e) => {
    setEmail(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await fetch(`https://d6r2lqnwvf7f5jd7663apyuqgq0qknqw.lambda-url.us-west-2.on.aws?email=${email}`, {
        method: 'GET',
        // Add any headers or other configurations as needed
      });
      console.log(response)
      if (response.ok) {
        const result = await response.json();
        setData(result);
      } else {
        setError(true);
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
        <h2>Analyzing Performance of Serverless Clusters with vHive and In-Vitro @ SESAME25</h2>
        <div className="logo-container">
          <img src={"/sosp-tutorial-infra-setup/vhive-logo.png"}  alt="vHive Logo" width={'150px'}/>
          {/* <img src={"./vhive-logo.png"} alt="vHive Logo" width={'150px'}/> */}
        </div>
        {data ? (
    <div>
        <h3>SSH credentials for vHive</h3>
        <div style={{ display: 'flex', alignItems: 'center' }}>
      <div className="response-box">
        <div>
          <pre class="response-text">ssh vhive@{data.ip} -p 1000{data.port}</pre>   
        </div>
        <pre class="response-text">password : vhive@sesame</pre>       
        </div>
          <button
                className="copy-button"
                onClick={() => copyToClipboard(`ssh vhive@${data.ip} -p 1000${data.port}`)}
              >
           <FaCopy/>
          </button>
      </div>
      <h3 style={{marginTop:'20px'}}>SSH credentials for Invitro</h3>
      <div style={{ display: 'flex', alignItems: 'center' }}>
      <div className="response-box">
       
        <div>
          <pre class="response-text">ssh vhive@{data.ip} -p 2000{data.port}</pre>
         <pre class="response-text">password : vhive@sesame</pre>
        </div>
        
      </div>
      <button
            className="copy-button"
            onClick={() => copyToClipboard(`ssh vhive@${data.ip} -p 2000${data.port}`)}
          >
           <FaCopy/>
          </button>
     </div>
      
    </div>
  ) : (
    error ? (<>Sorry! User not found.</>):
    (
    <form onSubmit={handleSubmit}>
      <h4>Retrieve credentials for hands-on sessions</h4>
      <label>
        Email:
        <input  style={{marginTop:'10px',marginBottom:'15px'}} type="email" value={email} onChange={handleEmailChange} placeholder='abc@gmail.com' required />
      </label>
      <button type="submit" disabled={loading}>
        {loading ? 'Loading...' : 'Submit'}
      </button>
    </form>
    )
  )}
</div>
    );
  };

export default EmailForm;
