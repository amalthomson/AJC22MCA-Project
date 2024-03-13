// src/App.js

import React from 'react';
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import AdminDashboard from './components/AdminDashboard';
import FarmerDetailsReactPage from './components/FarmerDetails';
import BuyerDetailsReactPage from './components/BuyerDetails';
import LoginPage from './components/LoginPage';
import CategoryWiseProducts from './components/CategoryWiseProducts';

const App = () => {
  return (
    <Router>
      <Routes>
      <Route path="/" element={<LoginPage/>} />
      <Route path="/admin-dashboard" element={<AdminDashboard/>} />
      <Route path="/farmer-details" element={<FarmerDetailsReactPage/>} />
      <Route path="/buyer-details" element={<BuyerDetailsReactPage/>} />
      <Route path="/category-products" element={<CategoryWiseProducts/>} />
      </Routes>
    </Router>
  );
};

export default App;
