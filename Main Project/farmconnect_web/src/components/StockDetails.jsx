import React, { useState, useEffect } from 'react';
import { collection, query, where, getDocs } from 'firebase/firestore';
import firestore from '../firebase';

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

  return (
    <div>
      <h1>Stock Details</h1>
      <table>
        <thead>
          <tr>
            <th>Product Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Stock</th>
            <th>Image</th>
          </tr>
        </thead>
        <tbody>
          {stockDetails.map(stock => (
            <tr key={stock.id}>
              <td>{stock.productName}</td>
              <td>{stock.productDescription}</td>
              <td>{stock.productPrice}</td>
              <td>{stock.stock}</td>
              <td>
                <img src={stock.productImage} alt={stock.productName} style={{ width: '100px', height: '100px' }} />
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default StockDetails;
