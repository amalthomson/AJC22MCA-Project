// src/App.js

import React from 'react';
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import AdminDashboard from './components/AdminDashboard';
import FarmerDetailsReactPage from './components/FarmerDetails';
import BuyerDetailsReactPage from './components/BuyerDetails';
import LoginPage from './components/LoginPage';
import FarmerPendingReactPage from './components/FarmerPending';
import FarmerRejectedReactPage from './components/FarmerRejected';
import StockDetails from './components/StockDetails';
import PaymentDetails from './components/PaymentDetails';
import OrderDetails from './components/OrderDetails';
import ProductApproved from './components/ProductsApproved';
import ProductRejected from './components/ProductsRejected';
import ProductPending from './components/ProductsPending';
import CategoryDetails from './components/CategoryDetails';
import ReviewDetails from './components/ReviewDetails';
import AllProducts from './components/AllProducts';
import Farmers from './components/Farmers';
import Products from './components/Products';

const App = () => {
  return (
    <Router>
      <Routes>
      <Route path="/" element={<LoginPage/>} />
      <Route path="/admin-dashboard" element={<AdminDashboard/>} />
      <Route path="/farmer-details" element={<FarmerDetailsReactPage/>} />
      <Route path="/buyer-details" element={<BuyerDetailsReactPage/>} />
      <Route path="/farmer-pending" element={<FarmerPendingReactPage/>} />
      <Route path="/farmer-rejected" element={<FarmerRejectedReactPage/>} />
      <Route path="/all-products" element={<AllProducts/>} />
      <Route path="/stock-details" element={<StockDetails/>} />
      <Route path="/payment-details" element={<PaymentDetails/>} />
      <Route path="/order-details" element={<OrderDetails/>} />
      <Route path="/products-approved" element={<ProductApproved/>} />
      <Route path="/products-rejected" element={<ProductRejected/>} />
      <Route path="/products-pending" element={<ProductPending/>} />
      <Route path="/category-details" element={<CategoryDetails/>} />
      <Route path="/review-details" element={<ReviewDetails/>} />
      <Route path="/farmers" element={<Farmers/>} />
      <Route path="/products" element={<Products/>} />
      </Routes>
    </Router>
  );
};

export default App;
