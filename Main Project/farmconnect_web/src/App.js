// src/App.js

import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import AdminDashboard from './components/AdminDashboard';
import FarmerDetailsPage from './components/FarmerDetailsPage';

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/admin-dashboard" element={<AdminDashboard />} />
        <Route path="/farmer-details" element={<FarmerDetailsPage />} />
      </Routes>
    </Router>
  );
};

export default App;
