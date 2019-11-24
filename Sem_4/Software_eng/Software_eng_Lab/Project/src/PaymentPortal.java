import javax.imageio.*;
import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;
import java.sql.*;

// The class responsible for the payments for the booking

public class PaymentPortal extends JFrame {
	static PaymentPortal frame;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					frame = new PaymentPortal(args[0],args[1]);
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public PaymentPortal(String sport,String slot) {

		// Set the default close operation.
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Set the bounds
        setBounds(100,100,500,500);
		JPanel bg;
		
		// Set Background Image
        try {
            Image backgroundImage = javax.imageio.ImageIO.read(new File("images/sbi_new.jpg"));
            final Image bgima = backgroundImage.getScaledInstance(700, 500, Image.SCALE_DEFAULT);
            bg = new JPanel(new BorderLayout()) {
                @Override
                public void paintComponent(Graphics g) {
                    g.drawImage(bgima, -100, 0, null);
                }
            };
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        // Add the panel to the frame
        setContentPane(bg);
		
		// The Title
		JLabel heading = new JLabel("Payment Portal");
		heading.setForeground(Color.black);
		heading.setFont(new Font("Tahoma", Font.BOLD, 34));
		
		
		/* All TextFields */
		
		// Username TextField
		JTextField textFieldName = new JTextField("Account Holder Name");
		textFieldName.setBackground(new Color(150,150,155));
		textFieldName.setFont(new Font("Tahoma", Font.ITALIC, 12));
		textFieldName.setForeground(new Color(45,45,45));
		textFieldName.setHorizontalAlignment(0);

			// Adding focus listener
			textFieldName.addFocusListener(new FocusListener() {
				@Override
				public void focusGained(FocusEvent e) {
					if (textFieldName.getText().equals("Account Holder Name")) {
						textFieldName.setText("");
						textFieldName.setForeground(new Color(0,0,0));
						textFieldName.setFont(new Font("Tahoma", Font.BOLD, 14));
					}
				}
				@Override
				public void focusLost(FocusEvent e) {
					if (textFieldName.getText().isEmpty()) {
						textFieldName.setForeground(new Color(45,45,80));
						textFieldName.setFont(new Font("Tahoma", Font.ITALIC, 12));
						textFieldName.setHorizontalAlignment(0);
						textFieldName.setText("Account Holder Name");
					}
				}
				});

		// Account number
		JTextField textFieldNumber = new JTextField("Account Number");
		textFieldNumber.setBackground(new Color(150,150,155));
		textFieldNumber.setFont(new Font("Tahoma", Font.ITALIC, 12));
		textFieldNumber.setForeground(new Color(45,45,45));
		textFieldNumber.setHorizontalAlignment(0);

			// Adding focus listener
			textFieldNumber.addFocusListener(new FocusListener() {
				@Override
				public void focusGained(FocusEvent e) {
					if (textFieldNumber.getText().equals("Account Number")) {
						textFieldNumber.setText("");
						textFieldNumber.setForeground(new Color(0,0,45));
						textFieldNumber.setFont(new Font("Tahoma", Font.BOLD, 14));
					}
				}
				@Override
				public void focusLost(FocusEvent e) {
					if (textFieldNumber.getText().isEmpty()) {
						textFieldNumber.setForeground(new Color(45,45,80));
						textFieldNumber.setFont(new Font("Tahoma", Font.ITALIC, 12));
						textFieldNumber.setHorizontalAlignment(0);
						textFieldNumber.setText("Account Number");
					}
				}
				});

		// Amount
		JTextField textFieldAmount = new JTextField("Rs. 500/-");
		textFieldAmount.setBackground(new Color(150,150,155));
		textFieldAmount.setForeground(Color.BLACK);
		textFieldAmount.setFont(new Font("Tahoma", Font.BOLD, 14));
		textFieldAmount.setHorizontalAlignment(0);
		textFieldAmount.setEditable(false);
			
		
		// Branch Name
		JTextField textFieldCVV = new JTextField("Branch Name");
		textFieldCVV.setBackground(new Color(150,150,155));
		textFieldCVV.setFont(new Font("Tahoma", Font.ITALIC, 12));
		textFieldCVV.setHorizontalAlignment(0);
		textFieldCVV.setForeground(new Color(45,45,45));
			
			// Adding focus listener
			textFieldCVV.addFocusListener(new FocusListener() {
				@Override
				public void focusGained(FocusEvent e) {
					if (textFieldCVV.getText().equals("Branch Name")) {
						textFieldCVV.setText("");
						textFieldCVV.setForeground(new Color(0,0,45));
						textFieldCVV.setFont(new Font("Tahoma", Font.BOLD, 14));
					}
				}
				@Override
				public void focusLost(FocusEvent e) {
					if (textFieldCVV.getText().isEmpty()) {
						textFieldCVV.setForeground(new Color(45,45,80));
						textFieldCVV.setFont(new Font("Tahoma", Font.ITALIC, 12));
						textFieldCVV.setHorizontalAlignment(0);
						textFieldCVV.setText("Branch Name");
					}
				}
				});

		
		
		// IFSC TextField
		JTextField textFieldIFSC = new JTextField("Enter IFSC");
		textFieldIFSC.setBackground(new Color(150,150,155));
		textFieldIFSC.setFont(new Font("Tahoma", Font.ITALIC, 12));
		textFieldIFSC.setHorizontalAlignment(0);
		textFieldIFSC.setForeground(new Color(45,45,45));

			// Adding focus listener
			textFieldIFSC.addFocusListener(new FocusListener() {
				@Override
				public void focusGained(FocusEvent e) {
					if (textFieldIFSC.getText().equals("Enter IFSC")) {
						textFieldIFSC.setText("");
						textFieldIFSC.setForeground(new Color(0,0,45));
						textFieldIFSC.setFont(new Font("Tahoma", Font.BOLD, 14));
					}
				}
				@Override
				public void focusLost(FocusEvent e) {
					if (textFieldIFSC.getText().isEmpty()) {
						textFieldIFSC.setForeground(new Color(45,45,80));
						textFieldIFSC.setFont(new Font("Tahoma", Font.ITALIC, 12));
						textFieldIFSC.setHorizontalAlignment(0);
						textFieldIFSC.setText("Enter IFSC");
					}
				}
				});


		/* All Buttons */

		// Add Pay Button
		JButton btnNewButton = new JButton("Pay");
		btnNewButton.setBackground(new Color(9, 9, 42));
		btnNewButton.setForeground(Color.WHITE);
		btnNewButton.setFocusPainted(false);
		btnNewButton.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener for the button
			btnNewButton.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					
					// Confirmation Dialog Box
					int input = JOptionPane.showConfirmDialog(PaymentPortal.this, "Do you want to book Slot " + slot + " for "+sport+ " ?","Are you sure?",JOptionPane.YES_NO_OPTION);
					if( input == 0)
					{
						SlotDao.update(sport,1,Integer.parseInt(slot));
						JOptionPane.showMessageDialog(PaymentPortal.this,"Payment Successful!");
						DisplaySlot.main(new String[]{sport});
						frame.dispose();	
					}
				}
			});
		
		// Back button
		JButton btnBack = new JButton("Back");
		btnBack.setBackground(new Color(9, 9, 9));
		btnBack.setForeground(Color.WHITE);
		btnBack.setFocusPainted(false);
		btnBack.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Focus Listener
			btnBack.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					
					// Confirmation Dialog Box
					int input = JOptionPane.showConfirmDialog(PaymentPortal.this, "Do you want to really quit the payment portal?","Are you sure?",JOptionPane.YES_NO_OPTION);
					if( input == 0)
					{
						DisplaySlot.main(new String[]{sport});
						frame.dispose();
					}
				}
			});

		// Layout for the background
		GroupLayout gl_contentPane = new GroupLayout(bg);

		gl_contentPane.setHorizontalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(150)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING, false)
						.addComponent(textFieldName, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
						.addComponent(textFieldNumber, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
						.addComponent(textFieldAmount, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
						.addComponent(textFieldCVV, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
						.addComponent(textFieldIFSC, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
					)
					
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(110)
					.addComponent(heading)
					.addGap(144)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(180)
					.addComponent(btnNewButton, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE)
					.addGap(250)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(400)
					.addComponent(btnBack)
				)
		);

		gl_contentPane.setVerticalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					
					.addGap(15)
					.addComponent(heading)
					
					.addGap(25)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
						
						.addGroup(gl_contentPane.createSequentialGroup()
							.addComponent(textFieldName, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
							.addGap(25)
							.addComponent(textFieldNumber, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
						)
					)
					
					.addGap(25)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						// .addComponent(lblEmailIcon)
						.addComponent(textFieldAmount, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
					)

					.addGap(25)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						// .addComponent(lblIDIcon)
						.addComponent(textFieldCVV, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
					)

					.addGap(25)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						// .addComponent(lblPhoneIcon)
						.addComponent(textFieldIFSC, GroupLayout.PREFERRED_SIZE, 32, GroupLayout.PREFERRED_SIZE)
					)

					.addGap(40)
					.addComponent(btnNewButton, GroupLayout.PREFERRED_SIZE, 36, GroupLayout.PREFERRED_SIZE)
					
					.addGap(25)
					.addComponent(btnBack, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE)
				)
		);
		bg.setLayout(gl_contentPane);
	}

}
