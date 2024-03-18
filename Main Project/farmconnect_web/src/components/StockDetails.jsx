import React, { useState, useEffect } from 'react';
import { collection, query, where, getDocs } from 'firebase/firestore';
import firestore from '../firebase';
import Sidebar from './SideBar';
import './StockDetails.css';

const StockDetails = () => {
  const [stockDetails, setStockDetails] = useState([]);

  useEffect(() => {
    const fetchStockDetails = async () => {
      try {
        const q = query(collection(firestore, 'products'), where('isApproved', '==', 'Approved'));
        const querySnapshot = await getDocs(q);

        const data = querySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        
        setStockDetails(data);
      } catch (error) {
        console.error('Error fetching stock details:', error);
      }
    };

    fetchStockDetails();

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
            <h3 className="text-center mt-4 mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
              Stock
            </h3>
          </div>
        <div className="container">
          <div className="stock-cards">
            {stockDetails.map(stock => (
              <div key={stock.id} className="card">
                <img src={stock.productImage} alt={stock.productName} className="card-image" />
                <div className="card-content">
                  <h4 className="card-title">{stock.productName}</h4>
                  <p className="card-price">Price: ₹ {stock.productPrice}.00</p>
                  <p className="card-stock">Stock: {stock.stock}/KG</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default StockDetails;
