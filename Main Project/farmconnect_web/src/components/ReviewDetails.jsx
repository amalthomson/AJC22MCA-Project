import React, { useState, useEffect } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import firestore from '../firebase';
import Sidebar from './SideBar';
import './ReviewDetails.css';

const ReviewDetails = () => {
  const [reviewDetails, setReviewDetails] = useState([]);

  useEffect(() => {
    const fetchReviewDetails = async () => {
      try {
        const q = collection(firestore, 'reviews');
        const querySnapshot = await getDocs(q);

        const data = querySnapshot.docs.map(doc => ({
          id: doc.id,
          category: doc.data().category,
          productId: doc.data().productId,
          productName: doc.data().productName,
          rating: doc.data().rating,
          reviewText: doc.data().reviewText,
          timestamp: doc.data().timestamp.toDate().toLocaleString()
        }));
        
        setReviewDetails(data);
      } catch (error) {
        console.error('Error fetching review details:', error);
      }
    };

    fetchReviewDetails();
    
    return () => {
      // Clean up any ongoing operations, if necessary
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
              Product Review
            </h3>
          </div>
        <div className="container">
          <div className="review-cards">
            {reviewDetails.map(review => (
              <div key={review.id} className="card">
                <div className="card-content">
                  <h3 className="category">{review.category}</h3>
                  <p><strong>Product ID:</strong> {review.productId}</p>
                  <p><strong>Product Name:</strong> {review.productName}</p>
                  <p><strong>Rating:</strong> {review.rating}/5.0</p>
                  <p><strong>Review Text:</strong> {review.reviewText}</p>
                  <p><strong>Timestamp:</strong> {review.timestamp}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ReviewDetails;
