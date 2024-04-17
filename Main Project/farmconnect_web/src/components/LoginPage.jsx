import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './LoginPage.css';

const LoginPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleLogin = () => {
    if (email === 'admin' && password === 'admin') {
      const token = 'admintokensession';
      localStorage.setItem('token', token);
      navigate('/admin-dashboard');
    } else {
      alert('Invalid email or password');
    }
  };

  return (
    <div className="login-container">
      <div className="login-header">
        <img className="logo" src="assets/appLogoDark.png" alt="Logo" />
        <h1>FarmConnect</h1>
      </div>
      <form>
        <label htmlFor="email">Email</label>
        <input
          type="email"
          id="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="Enter your email"
        />

        <label htmlFor="password">Password</label>
        <input
          type="password"
          id="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          placeholder="Enter your password"
        />

        <button type="button" onClick={handleLogin}>
          Login
        </button>
      </form>
    </div>
  );
};

export default LoginPage;
