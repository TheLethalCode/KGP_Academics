import javax.imageio.*;
import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;

// Class responsible for the Gymkhana/Admin Login Form

public class GymkhanaLogin extends JFrame {
	static GymkhanaLogin frame;
	private JTextField textField;
	private JPasswordField passwordField;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					frame = new GymkhanaLogin();
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
	public GymkhanaLogin() {
		
		// Set the default close operation.
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Set the bounds
        setBounds(100,100,500,500);
		JPanel bg;
		
		// Set Background Image
        try {
            Image backgroundImage = javax.imageio.ImageIO.read(new File("images/encryption.jpg"));
            final Image bgima = backgroundImage.getScaledInstance(650, 500, Image.SCALE_DEFAULT);
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
		JLabel heading = new JLabel("Admin Login");
		heading.setForeground(new Color(0,0,45));
		heading.setFont(new Font("Tahoma", Font.BOLD, 34));
		
		// User Icon Label
		ImageIcon imageIcon = new ImageIcon("images/fa-user.png");
		Image image = imageIcon.getImage(); // transform it into image
		Image newimg = image.getScaledInstance(30, 30,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblUserIcon = new JLabel(imageIcon); 
		
		// Key Icon Label
		imageIcon = new ImageIcon("images/fa-key.png");
		image = imageIcon.getImage(); // transform it into image
		newimg = image.getScaledInstance(30, 30,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblKeyIcon = new JLabel(imageIcon);
		
		// Username TextField
		textField = new JTextField("Enter username");
		textField.setBackground(new Color(200,200,205));
		textField.setFont(new Font("Tahoma", Font.ITALIC, 12));
		textField.setHorizontalAlignment(0);

			// Adding focus listener
			textField.addFocusListener(new FocusListener() {
				@Override
				public void focusGained(FocusEvent e) {
					if (textField.getText().equals("Enter username")) {
						textField.setText("");
						textField.setForeground(new Color(0,0,45));
						textField.setFont(new Font("Tahoma", Font.BOLD, 14));
					}
				}
				@Override
				public void focusLost(FocusEvent e) {
					if (textField.getText().isEmpty()) {
						textField.setForeground(new Color(45,45,80));
						textField.setFont(new Font("Tahoma", Font.ITALIC, 12));
						textField.setHorizontalAlignment(0);
						textField.setText("Enter username");
					}
				}
				});
		
		// Password field
		passwordField = new JPasswordField();
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

			// Enter key for logging in.
			passwordField.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					String name=textField.getText();
					String password=String.valueOf(passwordField.getPassword());
					if(name.equals("admin") && password.equals("admin123")){
						GymkhanaSuccess.main(new String[]{});
						frame.dispose();
					}else{
						JOptionPane.showMessageDialog(GymkhanaLogin.this, "Wrong Username or Password","Login Error!", JOptionPane.ERROR_MESSAGE);
						
						textField.setText("Enter username");
						textField.setFont(new Font("Tahoma", Font.ITALIC, 12));

						passwordField.setText("@@@@@");
					}
				}
			});
			
		// The Login Button
		JButton btnLogin = new JButton("Login");
		btnLogin.setBackground(new Color(17, 12, 58));
        btnLogin.setForeground(Color.WHITE);
        btnLogin.setFocusPainted(false);
		btnLogin.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener for Login Button
			btnLogin.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
				String name=textField.getText();
				String password=String.valueOf(passwordField.getPassword());
				if(name.equals("admin") && password.equals("admin123")){
					GymkhanaSuccess.main(new String[]{});
					frame.dispose();
				}else{
					JOptionPane.showMessageDialog(GymkhanaLogin.this, "Wrong Username or Password","Login Error!", JOptionPane.ERROR_MESSAGE);
					
					textField.setText("Enter username");
					textField.setFont(new Font("Tahoma", Font.ITALIC, 12));

					passwordField.setText("@@@@@");
				}
			}
			});

		// The Back Button
		JButton btnBack = new JButton("Back");
		btnBack.setBackground(new Color(17, 12, 58));
        btnBack.setForeground(Color.WHITE);
        btnBack.setFocusPainted(false);
		btnBack.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener for Back Button
			btnBack.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					Management_System.main(new String[]{});
					frame.dispose();
				}
			});
		
		GroupLayout gl_contentPane = new GroupLayout(bg);
		
		// Set the horizontal Layout
		gl_contentPane.setHorizontalGroup(
			gl_contentPane.createParallelGroup(Alignment.TRAILING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
						.addGroup(gl_contentPane.createSequentialGroup()
							.addGap(124)
							.addComponent(heading)
						)
						.addGroup(gl_contentPane.createSequentialGroup()
							.addGap(121)
							.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
								.addComponent(lblUserIcon)
								.addComponent(lblKeyIcon)
							)
							.addGap(14)
							.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING, false)
								.addComponent(passwordField)
								.addComponent(textField, GroupLayout.DEFAULT_SIZE, 172, Short.MAX_VALUE)
							)
						)
					)
					.addContainerGap(107, Short.MAX_VALUE))
				.addGroup(gl_contentPane.createSequentialGroup()
					.addContainerGap(10, Short.MAX_VALUE)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
						.addComponent(btnLogin, GroupLayout.PREFERRED_SIZE, 86, GroupLayout.PREFERRED_SIZE)
						.addComponent(btnBack, GroupLayout.PREFERRED_SIZE, 86, GroupLayout.PREFERRED_SIZE)
					)
					.addGap(201)
				)
		);

		// Set the vertical Layout
		gl_contentPane.setVerticalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(10)
					.addComponent(heading)
					.addGap(116)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblUserIcon)
						.addComponent(textField, GroupLayout.PREFERRED_SIZE, 27, GroupLayout.PREFERRED_SIZE))
					.addGap(38)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblKeyIcon)
						.addComponent(passwordField, GroupLayout.PREFERRED_SIZE, 27, GroupLayout.PREFERRED_SIZE))
					.addGap(50)
					.addComponent(btnLogin, GroupLayout.PREFERRED_SIZE, 37, GroupLayout.PREFERRED_SIZE)
					.addGap(20)
					.addComponent(btnBack, GroupLayout.PREFERRED_SIZE, 37, GroupLayout.PREFERRED_SIZE)
					.addContainerGap(80, Short.MAX_VALUE))
		);
		bg.setLayout(gl_contentPane);
	}
}
