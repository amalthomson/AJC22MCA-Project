// src/components/AdminDashboard.js
import React, { useState, useEffect } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import { Link } from 'react-router-dom'; 
import firestore from '../firebase';
import './AdminDashboard.css';

const AdminDashboard = () => {
  const [numberOfFarmers, setNumberOfFarmers] = useState(0);
  const [numberOfBuyers, setNumberOfBuyers] = useState(0);
  const [farmerApprovalPending, setFarmerApprovalPending] = useState(0);
  const [pendingProducts, setPendingProducts] = useState(0);
  const [farmerApprovalRejected, setFarmerApprovalRejected] = useState(0);
  const [rejectedProducts, setRejectedProducts] = useState(0);
  const [approvedProducts, setApprovedProducts] = useState(0);
  const [numberOfPayments, setNumberOfPayments] = useState(0);

  useEffect(() => {
    const fetchStatistics = async () => {
      try {
        const farmersRef = collection(firestore, 'users');
        const buyersRef = collection(firestore, 'users');
        const productsRef = collection(firestore, 'products');
        const paymentsRef = collection(firestore, 'payments');

        const farmersSnapshot = await getDocs(farmersRef);
        const buyersSnapshot = await getDocs(buyersRef);
        const pendingProductsSnapshot = await getDocs(productsRef.where('isApproved', '==', 'Pending'));
        const rejectedProductsSnapshot = await getDocs(productsRef.where('isApproved', '==', 'Rejected'));
        const approvedProductsSnapshot = await getDocs(productsRef.where('isApproved', '==', 'Approved'));
        const paymentsSnapshot = await getDocs(paymentsRef);

        setNumberOfFarmers(farmersSnapshot.docs.length);
        setNumberOfBuyers(buyersSnapshot.docs.length);
        setFarmerApprovalPending(farmersSnapshot.docs.filter(doc => doc.data().approvalStatus === 'Pending').length);
        setPendingProducts(pendingProductsSnapshot.docs.length);
        setFarmerApprovalRejected(farmersSnapshot.docs.filter(doc => doc.data().approvalStatus === 'Rejected').length);
        setRejectedProducts(rejectedProductsSnapshot.docs.length);
        setApprovedProducts(approvedProductsSnapshot.docs.length);
        setNumberOfPayments(paymentsSnapshot.docs.length);
      } catch (error) {
        console.error('Error fetching statistics:', error);
      }
    };

    fetchStatistics();
  }, []);

  return (
    <div>
      <h1 className="dashboard-title">Admin Dashboard</h1>
      <div className="dashboard-grid">
        <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
            <div className="dashboard-tile farmers-tile">
            <h2>Farmers</h2>
            <p>Count: {numberOfFarmers}</p>
            </div>
        </Link>
        <div className="dashboard-tile buyers-tile">
          <h2>Buyers</h2>
          <p>Count: {numberOfBuyers}</p>
        </div>
        <div className="dashboard-tile farmer-approval-pending-tile">
          <h2>Farmer Approval Pending</h2>
          <p>Count: {farmerApprovalPending}</p>
        </div>
        <div className="dashboard-tile pending-products-tile">
          <h2>Pending Product Approval</h2>
          <p>Count: {pendingProducts}</p>
        </div>
        <div className="dashboard-tile farmer-approval-rejected-tile">
          <h2>Farmer Approval Rejected</h2>
          <p>Count: {farmerApprovalRejected}</p>
        </div>
        <div className="dashboard-tile rejected-products-tile">
          <h2>Rejected Products</h2>
          <p>Count: {rejectedProducts}</p>
        </div>
        <div className="dashboard-tile approved-products-tile">
          <h2>Approved Products</h2>
          <p>Count: {approvedProducts}</p>
        </div>
        <div className="dashboard-tile stock-tile">
          <h2>Stock</h2>
          <p>Count: {approvedProducts}</p>
        </div>
        <div className="dashboard-tile payments-successful-tile">
          <h2>Payments Successful</h2>
          <p>Count: {numberOfPayments}</p>
        </div>
        <div className="dashboard-tile products-category-wise-tile">
          <h2>Products Category Wise</h2>
          <p>Count: 5</p>
        </div>
        <div className="dashboard-tile add-category-product-tile">
          <h2>Add Category and Product</h2>
          <p>Icon: +</p>
        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;
