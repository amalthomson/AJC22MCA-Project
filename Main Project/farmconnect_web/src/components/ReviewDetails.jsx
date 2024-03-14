import React, { useState, useEffect } from 'react';
import { collection, query, getDocs } from 'firebase/firestore';
import firestore from '../firebase';

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

    // Cleanup function
    return () => {
      // Clean up any ongoing operations, such as closing listeners, if necessary
    };
  }, []); // Empty dependency array ensures this effect runs only once on component mount

  return (
    <div>
      <h1>Review Details</h1>
      <table>
        <thead>
          <tr>
            <th>Category</th>
            <th>Product ID</th>
            <th>Product Name</th>
            <th>Rating</th>
            <th>Review Text</th>
            <th>Timestamp</th>
          </tr>
        </thead>
        <tbody>
          {reviewDetails.map(review => (
            <tr key={review.id}>
              <td>{review.category}</td>
              <td>{review.productId}</td>
              <td>{review.productName}</td>
              <td>{review.rating}</td>
              <td>{review.reviewText}</td>
              <td>{review.timestamp}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ReviewDetails;
