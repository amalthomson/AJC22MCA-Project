import React, { useState, useEffect } from 'react';
import { collection, query, where, getDocs } from 'firebase/firestore';
import firestore from '../firebase';
import Sidebar from './SideBar';
import './ProductsPending.css';

const ProductPending = () => {
  const [productDetails, setProductDetails] = useState([]);

  useEffect(() => {
    const fetchProductDetails = async () => {
      try {
        const q = query(collection(firestore, 'products'), where('isApproved', '==', 'Pending'));
        const querySnapshot = await getDocs(q);

        const data = querySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        
        setProductDetails(data);
      } catch (error) {
        console.error('Error fetching product details:', error);
      }
    };

    fetchProductDetails();

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
            <h3 className="text-center mt-4 mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
              Products - Pending
            </h3>
          </div>
        <div className="product-cards">
          {productDetails.map(product => (
            <div key={product.id} className="card">
              <img src={product.productImage} alt={product.productName} className="card-image" />
              <div className="card-content">
                <h4 className="card-title">{product.productName}</h4>
                <p className="card-price">Price: ₹ {product.productPrice}.00</p>
                <p className="card-category">Category: {product.category}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ProductPending;
