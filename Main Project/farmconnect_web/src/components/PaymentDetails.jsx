import React, { useState, useEffect } from 'react';
import { collection, query, getDocs } from 'firebase/firestore';
import firestore from '../firebase';
import './PaymentDetails.css'; // Import the CSS file
import Sidebar from './SideBar';

const PaymentDetails = () => {
  const [paymentDetails, setPaymentDetails] = useState([]);

  useEffect(() => {
    const fetchPaymentDetails = async () => {
      try {
        const q = query(collection(firestore, 'payments'));
        const querySnapshot = await getDocs(q);

        const data = querySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        
        setPaymentDetails(data);
      } catch (error) {
        console.error('Error fetching payment details:', error);
      }
    };

    fetchPaymentDetails();

    // Cleanup function
    return () => {
      // Clean up any ongoing operations, such as closing listeners, if necessary
    };
  }, []); // Empty dependency array ensures this effect runs only once on component mount

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
              Payments
            </h3>
          </div>
        <div className="payment-details-container">
          {paymentDetails.map(payment => (
            <div className="payment-card" key={payment.id}>
              <div className="card-header">
                <h4>Payment ID: {payment.paymentId}</h4>
              </div>
              <div className="card-body">
                <p><strong>Amount:</strong> ₹ {payment.amount}.00</p>
                <p><strong>Timestamp:</strong> {new Date(payment.timestamp?.toDate()).toLocaleString()}</p>
                <p><strong>Customer Name:</strong> {payment.customerName}</p>
                <p><strong>Customer Email:</strong> {payment.customerEmail}</p>
                <div className="products-list">
                  <h5>Products:</h5>
                  <div className="products-container">
                    {payment.products.map((product, index) => (
                      <div className="product" key={index}>
                        <p><strong>Name:</strong> {product.productName}</p>
                        <p><strong>Quantity:</strong> {product.quantity} KG</p>
                        <p><strong>Unit Price:</strong> ₹ {product.unitPrice.toFixed(2)}.00</p>
                        <p><strong>Total Price:</strong> ₹ {product.totalPrice.toFixed(2)}.00</p>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default PaymentDetails;
