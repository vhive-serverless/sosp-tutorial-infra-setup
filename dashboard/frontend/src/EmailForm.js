/**
# MIT License
#
# Copyright (c) 2023 Dilina Dehigama and EASE Lab
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
*/

import React, { useState } from 'react';
import './App.css'; // Import the CSS file for styling
import { FaCopy } from 'react-icons/fa';
const {lambda_proxy_url} = require('./proxy_url');

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
    // Using a Lambda function as a proxy
    try {
      const response = await fetch(`${lambda_proxy_url}/?email=${email}`, {
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
        <h2>The 2nd Tutorial on vHive & Serverless Research</h2>
        <div className="logo-container">
          <img src={"/sosp-tutorial-infra-setup/vhive-logo.png"}  alt="vHive Logo" width={'150px'}/>
        </div>
        {data ? (

    <div>
        <h3>SSH credentials for vHive (hands-on session 1)</h3>
        <div style={{ display: 'flex', alignItems: 'center' }}>
      <div className="response-box">
        <div>
          <pre class="response-text">ssh vhive@{data.user_vm_mapping.vm_ip} -L 9411:127.0.0.1:9411 -p 1000{data.user_vm_mapping.port} </pre>   
        </div>
        <pre class="response-text">password : #SamplePassword</pre>       
        </div>
          <button
                className="copy-button"
                onClick={() => copyToClipboard(`ssh vhive@${data.user_vm_mapping.vm_ip} -L 9411:127.0.0.1:9411 -p 1000${data.user_vm_mapping.port} `)}
              >
           <FaCopy/>
          </button>
      </div>
      <h3 style={{marginTop:'20px'}}>SSH credentials for In-Vitro (hands-on session 2)</h3>
      <div style={{ display: 'flex', alignItems: 'center' }}>
      <div className="response-box">
       
        <div>
          <pre class="response-text">ssh vhive@{data.user_vm_mapping.vm_ip} -p 2000{data.user_vm_mapping.port}</pre>
         <pre class="response-text">password : #SamplePassword</pre>
        </div>
        
      </div>
      <button
            className="copy-button"
            onClick={() => copyToClipboard(`ssh vhive@${data.user_vm_mapping.vm_ip} -p 2000${data.user_vm_mapping.port}`)}
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
