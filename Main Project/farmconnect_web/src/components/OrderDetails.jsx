import React, { useState, useEffect } from 'react';
import { collection, query, getDocs } from 'firebase/firestore';
import firestore from '../firebase';
import './OrderDetails.css';
import Sidebar from './SideBar';

const OrderDetails = () => {
  const [orderDetails, setOrderDetails] = useState([]);

  useEffect(() => {
    const fetchOrderDetails = async () => {
      try {
        const q = query(collection(firestore, 'orders'));
        const querySnapshot = await getDocs(q);

        const data = querySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));

        setOrderDetails(data);
      } catch (error) {
        console.error('Error fetching order details:', error);
      }
    };

    fetchOrderDetails();

    return () => {
    };
  }, []); 

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      window.location.href = '/'; 
    }
  }, []);

  return (
    <div className="wrapper">
      <Sidebar />
      <div className="content">
      <div className="w-100 d-flex justify-content-center align-items-center">
            <h3 className="text-center mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
              Orders
            </h3>
          </div>
        <div className="order-details-container">
          <div className="order-cards-container">
            {orderDetails.map(order => (
              <div key={order.id} className="order-card">
                <div className="order-header">
                  <h4>Order ID: {order.orderId}</h4>
                </div>
                <div className="order-details">
                  <p><strong>Timestamp:</strong> {new Date(order.timestamp?.toDate()).toLocaleString()}</p>
                  <p><strong>Payment ID:</strong> {order.paymentId}</p>
                  <p><strong>Amount:</strong> ₹ {order.amount}.00</p>
                  <p><strong>Customer Name:</strong> {order.customerName}</p>
                  <p><strong>Customer Email:</strong> {order.customerEmail}</p>
                </div>
                <div className="product-list">
                  <h5>Products:</h5>
                  <div className="product-items">
                    {order.products.map((product, index) => (
                      <div key={index} className="product-item">
                        <p><strong>Name:</strong> {product.productName}</p>
                        <p><strong>Quantity:</strong> {product.quantity}</p>
                        <p><strong>Unit Price:</strong> ₹ {product.unitPrice.toFixed(2)}.00</p>
                        <p><strong>Total Price:</strong> ₹ {product.totalPrice.toFixed(2)}.00</p>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default OrderDetails;
