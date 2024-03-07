// src/components/Login.js

import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Login.css';

const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleLogin = () => {
    if (email === 'admin' && password === '123') {
      navigate('/admin-dashboard');
    } else {
      alert('Invalid email or password');
    }
  };

  return (
    <div className="login-container">
      <div className="login-header">
        <img className="logo" src="/path/to/your/logo.png" alt="FarmConnect Logo" />
        <h1>FarmConnect</h1>
      </div>
      <form>
        <label>Email:</label>
        <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} />

        <label>Password:</label>
        <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} />

        <button type="button" onClick={handleLogin}>
          Login
        </button>
      </form>
    </div>
  );
};

export default Login;
