import React, { useState, useEffect } from 'react';
import { collection, query, getDocs } from 'firebase/firestore';
import firestore from '../firebase';

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

  return (
    <div>
      <h1>Payment Details</h1>
      <table>
        <thead>
          <tr>
            <th>Payment ID</th>
            <th>Amount</th>
            <th>Timestamp</th>
            <th>Customer Name</th>
            <th>Customer Email</th>
            <th>Products</th>
          </tr>
        </thead>
        <tbody>
          {paymentDetails.map(payment => (
            <tr key={payment.id}>
              <td>{payment.paymentId}</td>
              <td>{payment.amount}</td>
              <td>{payment.timestamp.toDate().toLocaleString()}</td>
              <td>{payment.customerName}</td>
              <td>{payment.customerEmail}</td>
              <td>
                <ul>
                  {payment.products.map((product, index) => (
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

export default PaymentDetails;
