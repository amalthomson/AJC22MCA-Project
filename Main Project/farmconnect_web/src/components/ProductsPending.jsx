import React, { useState, useEffect } from 'react';
import { collection, query, where, getDocs } from 'firebase/firestore';
import firestore from '../firebase';

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

    // Cleanup function
    return () => {
      // Clean up any ongoing operations, such as closing listeners, if necessary
    };
  }, []); // Empty dependency array ensures this effect runs only once on component mount

  return (
    <div>
      <h1>Product Details (Pending)</h1>
      <table>
        <thead>
          <tr>
            <th>Product Name</th>
            <th>Price</th>
            <th>Description</th>
            <th>Category</th>
            <th>Image</th>
          </tr>
        </thead>
        <tbody>
          {productDetails.map(product => (
            <tr key={product.id}>
              <td>{product.productName}</td>
              <td>{product.productPrice}</td>
              <td>{product.productDescription}</td>
              <td>{product.category}</td>
              <td>
                <img src={product.productImage} alt={product.productName} style={{ width: '100px', height: '100px' }} />
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ProductPending;
