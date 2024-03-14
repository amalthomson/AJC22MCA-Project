import React, { useState, useEffect } from 'react';
import { collection, query, getDocs } from 'firebase/firestore';
import firestore from '../firebase';

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

    // Cleanup function
    return () => {
      // Clean up any ongoing operations, such as closing listeners, if necessary
    };
  }, []); // Empty dependency array ensures this effect runs only once on component mount

  return (
    <div>
      <h1>Order Details</h1>
      <table>
        <thead>
          <tr>
            <th>Order ID</th>
            <th>Payment ID</th>
            <th>Amount</th>
            <th>Timestamp</th>
            <th>Customer Name</th>
            <th>Customer Email</th>
            <th>Products</th>
          </tr>
        </thead>
        <tbody>
          {orderDetails.map(order => (
            <tr key={order.id}>
              <td>{order.orderId}</td>
              <td>{order.paymentId}</td>
              <td>{order.amount}</td>
              <td>{order.timestamp.toDate().toLocaleString()}</td>
              <td>{order.customerName}</td>
              <td>{order.customerEmail}</td>
              <td>
                <ul>
                  {order.products.map((product, index) => (
                    <li key={index}>
                      Product ID: {product.productId}, 
                      Name: {product.productName}, 
                      Quantity: {product.quantity}, 
                      Unit Price: {product.unitPrice}, 
                      Total Price: {product.totalPrice}
                    </li>
                  ))}
                </ul>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default OrderDetails;
