import javax.imageio.*;
import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;
import java.sql.*;

// Class responsible for adding new users to the database

public class UserForm extends JFrame {
	static UserForm frame;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					frame = new UserForm();
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
	public UserForm() {

		// Set the default close operation.
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Set the bounds
        setBounds(100,100,500,500);
		JPanel bg;
		
		// Set Background Image
        try {
            Image backgroundImage = javax.imageio.ImageIO.read(new File("images/addUser.png"));
            final Image bgima = backgroundImage.getScaledInstance(500, 500, Image.SCALE_DEFAULT);
            bg = new JPanel(new BorderLayout()) {
                @Override
                public void paintComponent(Graphics g) {
                    g.drawImage(bgima, 0, 0, null);
                }
            };
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        // Add the panel to the frame
        setContentPane(bg);
		
		// The Title
		JLabel heading = new JLabel("Add New User");
		heading.setForeground(new Color(210,250,210));
		heading.setFont(new Font("Tahoma", Font.BOLD, 34));
		
		/* All Labels */

		// User Icon Label
		ImageIcon imageIcon = new ImageIcon("images/fa-user1.png");
		Image image = imageIcon.getImage(); // transform it into image
		Image newimg = image.getScaledInstance(25, 25,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblUserIcon = new JLabel(imageIcon); 
		
		// Key Icon Label
		imageIcon = new ImageIcon("images/fa-key.png");
		image = imageIcon.getImage(); // transform it into image
		newimg = image.getScaledInstance(25, 25,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblKeyIcon = new JLabel(imageIcon);

		// Email Icon Label
		imageIcon = new ImageIcon("images/fa-email.png");
		image = imageIcon.getImage(); // transform it into image
		newimg = image.getScaledInstance(25, 25,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblEmailIcon = new JLabel(imageIcon);

		// ID Icon Label
		imageIcon = new ImageIcon("images/fa-id.png");
		image = imageIcon.getImage(); // transform it into image
		newimg = image.getScaledInstance(25, 25,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblIDIcon = new JLabel(imageIcon);

		// Phone Icon Label
		imageIcon = new ImageIcon("images/fa-phone.png");
		image = imageIcon.getImage(); // transform it into image
		newimg = image.getScaledInstance(25, 25,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblPhoneIcon = new JLabel(imageIcon);
		
		/* All TextFields */

		// Username TextField
		JTextField textFieldName = new JTextField("Enter username");
		textFieldName.setBackground(new Color(200,200,205));
		textFieldName.setFont(new Font("Tahoma", Font.ITALIC, 12));
		textFieldName.setHorizontalAlignment(0);

			// Adding focus listener
			textFieldName.addFocusListener(new FocusListener() {
				@Override
				public void focusGained(FocusEvent e) {
					if (textFieldName.getText().equals("Enter username")) {
						textFieldName.setText("");
						textFieldName.setForeground(new Color(0,0,45));
						textFieldName.setFont(new Font("Tahoma", Font.BOLD, 14));
					}
				}
				@Override
				public void focusLost(FocusEvent e) {
					if (textFieldName.getText().isEmpty()) {
						textFieldName.setForeground(new Color(45,45,80));
						textFieldName.setFont(new Font("Tahoma", Font.ITALIC, 12));
						textFieldName.setHorizontalAlignment(0);
						textFieldName.setText("Enter username");
					}
				}
				});
		
		// Password field
		JPasswordField passwordField = new JPasswordField();
		passwordField.setBackground(new Color(200,200,205));
		passwordField.setFont(new Font("Tahoma", Font.BOLD, 14));
		passwordField.setHorizontalAlignment(0);
		passwordField.setText("@@@@@");

			// Adding focus listener for the password
			passwordField.addFocusListener(new FocusListener() {
			@Override
			public void focusGained(FocusEvent e) {
				if (passwordField.getText().equals("@@@@@")) {
					passwordField.setText("");
					passwordField.setForeground(new Color(0,0,45));
					passwordField.setFont(new Font("Tahoma", Font.BOLD, 14));
				}
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (passwordField.getText().isEmpty()) {
					passwordField.setForeground(new Color(45,45,80));
					passwordField.setFont(new Font("Tahoma", Font.ITALIC, 14));
					passwordField.setHorizontalAlignment(0);
					passwordField.setText("@@@@@");
				}
			}
			});
		
		// Email TextField
		JTextField textFieldEmail = new JTextField("Enter Email ID");
		textFieldEmail.setBackground(new Color(200,200,205));
		textFieldEmail.setFont(new Font("Tahoma", Font.ITALIC, 12));
		textFieldEmail.setHorizontalAlignment(0);

			// Adding focus listener
			textFieldEmail.addFocusListener(new FocusListener() {
				@Override
				public void focusGained(FocusEvent e) {
					if (textFieldEmail.getText().equals("Enter Email ID")) {
						textFieldEmail.setText("");
						textFieldEmail.setForeground(new Color(0,0,45));
						textFieldEmail.setFont(new Font("Tahoma", Font.BOLD, 14));
					}
				}
				@Override
				public void focusLost(FocusEvent e) {
					if (textFieldEmail.getText().isEmpty()) {
						textFieldEmail.setForeground(new Color(45,45,80));
						textFieldEmail.setFont(new Font("Tahoma", Font.ITALIC, 12));
						textFieldEmail.setHorizontalAlignment(0);
						textFieldEmail.setText("Enter Email ID");
					}
				}
				});
		
		// Stakeholder Code TextField
		JTextField textFieldID = new JTextField("Enter ID");
		textFieldID.setBackground(new Color(200,200,205));
		textFieldID.setFont(new Font("Tahoma", Font.ITALIC, 12));
		textFieldID.setHorizontalAlignment(0);

			// Adding focus listener
			textFieldID.addFocusListener(new FocusListener() {
				@Override
				public void focusGained(FocusEvent e) {
					if (textFieldID.getText().equals("Enter ID")) {
						textFieldID.setText("");
						textFieldID.setForeground(new Color(0,0,45));
						textFieldID.setFont(new Font("Tahoma", Font.BOLD, 14));
					}
				}
				@Override
				public void focusLost(FocusEvent e) {
					if (textFieldID.getText().isEmpty()) {
						textFieldID.setForeground(new Color(45,45,80));
						textFieldID.setFont(new Font("Tahoma", Font.ITALIC, 12));
						textFieldID.setHorizontalAlignment(0);
						textFieldID.setText("Enter ID");
					}
				}
				});

		// Contact Number TextField
		JTextField textFieldContact = new JTextField("Enter Contact No.");
		textFieldContact.setBackground(new Color(200,200,205));
		textFieldContact.setFont(new Font("Tahoma", Font.ITALIC, 12));
		textFieldContact.setHorizontalAlignment(0);

			// Adding focus listener
			textFieldContact.addFocusListener(new FocusListener() {
				@Override
				public void focusGained(FocusEvent e) {
					if (textFieldContact.getText().equals("Enter Contact No.")) {
						textFieldContact.setText("");
						textFieldContact.setForeground(new Color(0,0,45));
						textFieldContact.setFont(new Font("Tahoma", Font.BOLD, 14));
					}
				}
				@Override
				public void focusLost(FocusEvent e) {
					if (textFieldContact.getText().isEmpty()) {
						textFieldContact.setForeground(new Color(45,45,80));
						textFieldContact.setFont(new Font("Tahoma", Font.ITALIC, 12));
						textFieldContact.setHorizontalAlignment(0);
						textFieldContact.setText("Enter Contact No.");
					}
				}
				});

		/* All Buttons */

		// Add New User Button
		JButton btnNewButton = new JButton("Add User");
		btnNewButton.setBackground(new Color(9, 9, 42));
		btnNewButton.setForeground(Color.WHITE);
		btnNewButton.setFocusPainted(false);
		btnNewButton.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener for the button
			btnNewButton.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {

					String name=textFieldName.getText();
					String password=String.valueOf(passwordField.getPassword());
					String email=textFieldEmail.getText();
					String id_no=textFieldID.getText();
					String residence = new String("Dummy");
					String contact=textFieldContact.getText();

					// Handle default textfield submissions
					if(name.trim().equals("Enter username"))
					{
						JOptionPane.showMessageDialog(UserForm.this,"Name can't be blank","Error",JOptionPane.ERROR_MESSAGE);
					}
					else if(password.trim().equals("@@@@@"))
					{
						JOptionPane.showMessageDialog(UserForm.this,"Password can't be the default one","Error",JOptionPane.ERROR_MESSAGE);
					}
					else if(!email.trim().contains("@"))
					{
						JOptionPane.showMessageDialog(UserForm.this,"Not a valid email","Error",JOptionPane.ERROR_MESSAGE);
					}
					else if(id_no.trim().equals("Enter ID"))
					{
						JOptionPane.showMessageDialog(UserForm.this,"User ID can't be blank","Error",JOptionPane.ERROR_MESSAGE);
					}
					else if(!contact.trim().matches("[0-9]+") || contact.trim().length() < 7)
					{
						JOptionPane.showMessageDialog(UserForm.this,"Not a valid contact number","Error",JOptionPane.ERROR_MESSAGE);
					}
					else
					{
						// Confirmation Dialog Box
						int input = JOptionPane.showConfirmDialog(UserForm.this, "Do you really want to add this user ?","Are you sure?",JOptionPane.YES_NO_OPTION);
						if( input == 0)
						{
							int i=UserDao.save(name, password, email, id_no, residence, contact);
							if(i>0){
								JOptionPane.showMessageDialog(UserForm.this,"User added successfully!");
								GymkhanaSuccess.main(new String[]{});
								frame.dispose();	
							}
							else{
								JOptionPane.showMessageDialog(UserForm.this,"Sorry, unable to save!");
							}
						}
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
				public void actionPerformed(ActionEvent e) 
				{
					// Confirmation Dialog Box
					int input = JOptionPane.showConfirmDialog(UserForm.this, "Do you want to really quit in between ?","Are you sure?",JOptionPane.YES_NO_OPTION);
					if( input == 0)
					{
						GymkhanaSuccess.main(new String[]{});
						frame.dispose();
					}
				}
			});

		// Layout for the background
		GroupLayout gl_contentPane = new GroupLayout(bg);

		gl_contentPane.setHorizontalGroup(
			gl_contentPane.createParallelGroup(Alignment.TRAILING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(130)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING, false)
						.addComponent(textFieldContact, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
						.addComponent(textFieldID, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
						.addComponent(textFieldEmail, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
						.addComponent(textFieldName, GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
						.addComponent(passwordField)
					)
					.addGap(20)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING, false)
						.addComponent(lblKeyIcon)
						.addComponent(lblUserIcon)
						.addComponent(lblEmailIcon)
						.addComponent(lblIDIcon)
						.addComponent(lblPhoneIcon)
					)
					.addContainerGap(107, Short.MAX_VALUE)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(110)
					.addComponent(heading)
					.addGap(144)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addComponent(btnNewButton, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE)
					.addGap(250)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addComponent(btnBack)
					.addGap(40)
				)
		);

		gl_contentPane.setVerticalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					
					.addGap(15)
					.addComponent(heading)
					
					.addGap(30)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
						.addGroup(gl_contentPane.createSequentialGroup()
							.addComponent(lblUserIcon)
							.addGap(30)
							.addComponent(lblKeyIcon)
						)
						.addGroup(gl_contentPane.createSequentialGroup()
							.addComponent(textFieldName, GroupLayout.PREFERRED_SIZE, 27, GroupLayout.PREFERRED_SIZE)
							.addGap(30)
							.addComponent(passwordField, GroupLayout.PREFERRED_SIZE, 27, GroupLayout.PREFERRED_SIZE)
						)
					)
					
					.addGap(30)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblEmailIcon)
						.addComponent(textFieldEmail, GroupLayout.PREFERRED_SIZE, 27, GroupLayout.PREFERRED_SIZE)
					)

					.addGap(30)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblIDIcon)
						.addComponent(textFieldID, GroupLayout.PREFERRED_SIZE, 27, GroupLayout.PREFERRED_SIZE)
					)

					.addGap(30)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblPhoneIcon)
						.addComponent(textFieldContact, GroupLayout.PREFERRED_SIZE, 27, GroupLayout.PREFERRED_SIZE)
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
