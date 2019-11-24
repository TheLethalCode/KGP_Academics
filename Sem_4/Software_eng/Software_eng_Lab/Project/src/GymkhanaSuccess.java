import javax.imageio.*;
import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;
import java.sql.*;

// The class responsible for the admin main page

public class GymkhanaSuccess extends JFrame {
	static GymkhanaSuccess frame;
	private JPanel contentPane;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					frame = new GymkhanaSuccess();
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
	public GymkhanaSuccess() {

		// Set Default close operation
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Set the bounds
        setBounds(100,100,500,500);
        JPanel bg;

        // Set Background Image
        try {
            Image backgroundImage = javax.imageio.ImageIO.read(new File("images/gymkhanaSuccess1.jpg"));
            final Image bgima = backgroundImage.getScaledInstance(700, 500, Image.SCALE_DEFAULT);
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

        // Set Heading
        JLabel heading = new JLabel("Administrative Actions");
		heading.setForeground(new Color(224,224,224));
		heading.setFont(new Font("Tahoma", Font.BOLD, 31));

		// Button for adding new user
		JButton btnNewButton = new JButton("Add User");
		btnNewButton.setFont(new Font("Tahoma", Font.BOLD, 16));
		btnNewButton.setBackground(new Color(25, 22, 28));
        btnNewButton.setForeground(Color.WHITE);
		btnNewButton.setFocusPainted(false);
		
			// Action Listener for the button
			btnNewButton.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
				UserForm.main(new String[]{});
				frame.dispose();
				}
			});
		
		// Button for deleting user 
		JButton btnDeleteUser = new JButton("Delete User");
		btnDeleteUser.setFont(new Font("Tahoma", Font.BOLD, 16));
		btnDeleteUser.setBackground(new Color(25, 22, 28));
        btnDeleteUser.setForeground(Color.WHITE);
		btnDeleteUser.setFocusPainted(false);

			// Action listener for the button	
			btnDeleteUser.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
				DeleteUser.main(new String[]{});
				frame.dispose();
				}
			});
		
		// Button for modifying slots
		JButton btnModifySlot = new JButton("Modify Slot");
		btnModifySlot.setFont(new Font("Tahoma", Font.BOLD, 16));
		btnModifySlot.setBackground(new Color(25, 22, 28));
        btnModifySlot.setForeground(Color.WHITE);
		btnModifySlot.setFocusPainted(false);

			// Action listener for the button
			btnModifySlot.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					ModifySlot.main(new String[]{});
					frame.dispose();
				}
			});
		
		// Button for logout
		JButton btnLogout = new JButton("Logout");
		btnLogout.setFont(new Font("Tahoma", Font.BOLD, 16));
		btnLogout.setBackground(new Color(25, 22, 28));
        btnLogout.setForeground(Color.WHITE);
		btnLogout.setFocusPainted(false);

			// Action listener for the button
			btnLogout.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					int input = JOptionPane.showConfirmDialog(GymkhanaSuccess.this, "Do you want to really logout ?","Are you sure?",JOptionPane.YES_NO_OPTION);
					if( input == 0)
					{
						Management_System.main(new String[]{});
						frame.dispose();
					}
				}
			});

		// Sets the background layout for the panel
		GroupLayout gl_contentPane = new GroupLayout(bg);
		gl_contentPane.setHorizontalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(45)
					.addComponent(heading)
				)
				.addGroup(Alignment.LEADING, gl_contentPane.createSequentialGroup()
					.addGap(160)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
						.addComponent(btnLogout, GroupLayout.PREFERRED_SIZE, 150, GroupLayout.PREFERRED_SIZE)
						.addComponent(btnDeleteUser, GroupLayout.PREFERRED_SIZE, 150, GroupLayout.PREFERRED_SIZE)
						.addComponent(btnModifySlot, GroupLayout.PREFERRED_SIZE, 150, GroupLayout.PREFERRED_SIZE)
						.addComponent(btnNewButton, GroupLayout.PREFERRED_SIZE, 150, GroupLayout.PREFERRED_SIZE)
					)
					.addContainerGap(109, Short.MAX_VALUE)
				)
		);

		gl_contentPane.setVerticalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(30)
					.addComponent(heading, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
					.addGap(51)
					.addComponent(btnNewButton, GroupLayout.PREFERRED_SIZE, 45, GroupLayout.PREFERRED_SIZE)
					.addGap(38)
					.addComponent(btnModifySlot, GroupLayout.PREFERRED_SIZE, 45, GroupLayout.PREFERRED_SIZE)
					.addGap(38)
					.addComponent(btnDeleteUser, GroupLayout.PREFERRED_SIZE, 45, GroupLayout.PREFERRED_SIZE)
					.addGap(38)
					.addComponent(btnLogout, GroupLayout.PREFERRED_SIZE, 45, GroupLayout.PREFERRED_SIZE)
					.addContainerGap(21, Short.MAX_VALUE)
				)
		);
		bg.setLayout(gl_contentPane);
	}
}
