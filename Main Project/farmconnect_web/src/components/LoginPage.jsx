import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './LoginPage.css';

const LoginPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleLogin = () => {
    if (email === 'admin' && password === '123') {
      const token = 'j22sxx338wzcvollrxz';
      localStorage.setItem('token', token);
      navigate('/admin-dashboard');
    } else {
      alert('Invalid email or password');
    }
  };

  return (
    <div className="login-container">
      <div className="login-header">
        <img className="logo" src="assets/appLogoDark.png"/>
        <h1>FarmConnect</h1>
      </div>
      <form>
        <label>Email</label>
        <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} />

        <label>Password</label>
        <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} />

        <button type="button" onClick={handleLogin}>
          Login
        </button>
      </form>
    </div>
  );
};

export default LoginPage;
