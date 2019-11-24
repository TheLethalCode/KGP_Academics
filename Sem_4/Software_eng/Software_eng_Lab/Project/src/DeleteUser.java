import javax.imageio.*;
import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;
import java.sql.*;

// Class responsible for deleting of an user by the admin

public class DeleteUser extends JFrame {
	static DeleteUser frame;
	private JPanel contentPane;
	private JTextField textField;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					frame = new DeleteUser();
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
	public DeleteUser() {

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
		JLabel heading = new JLabel("Delete User");
		heading.setForeground(new Color(210,250,210));
		heading.setFont(new Font("Tahoma", Font.BOLD, 37));
		
		// ID Icon Label
		ImageIcon imageIcon = new ImageIcon("images/fa-id.png");
		Image image = imageIcon.getImage(); // transform it into image
		Image newimg = image.getScaledInstance(25, 25,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblIDIcon = new JLabel(imageIcon);

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

		
		// Delete Button
		JButton btnDelete = new JButton("Delete User");
		btnDelete.setBackground(new Color(9, 9, 42));
		btnDelete.setForeground(Color.WHITE);
		btnDelete.setFocusPainted(false);
		btnDelete.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener
			btnDelete.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) 
				{
					String sid=textFieldID.getText();
					if(sid.trim().equals("Enter ID")){
						JOptionPane.showMessageDialog(DeleteUser.this,"Id can't be blank","Error",JOptionPane.ERROR_MESSAGE);
					}
					else
					{
						int input = JOptionPane.showConfirmDialog(DeleteUser.this, "Do you want to really delete this user ?","Are you sure?",JOptionPane.YES_NO_OPTION);
						if( input == 0)
						{
							String id=sid.trim();
							int i=UserDao.delete(id);
							if(i>0){
								JOptionPane.showMessageDialog(DeleteUser.this,"Record deleted successfully!");
							}else{
								JOptionPane.showMessageDialog(DeleteUser.this,"Given ID doesn't exist!");
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

			// Action Listener
			btnBack.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) 
				{
					int input = JOptionPane.showConfirmDialog(DeleteUser.this, "Do you want to really go back?","Are you sure?",JOptionPane.YES_NO_OPTION);
					if( input == 0)
					{
						GymkhanaSuccess.main(new String[]{});
						frame.dispose();
					}
				}
			});
		
		// Layout for the panel
		GroupLayout gl_contentPane = new GroupLayout(bg);
		gl_contentPane.setHorizontalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(123)
					.addComponent(heading)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(135)
					.addComponent(textFieldID, GroupLayout.PREFERRED_SIZE, 178, GroupLayout.PREFERRED_SIZE)
					.addGap(19)
					.addComponent(lblIDIcon)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(160)
					.addComponent(btnDelete, GroupLayout.PREFERRED_SIZE, 130, GroupLayout.PREFERRED_SIZE)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(380)
					.addComponent(btnBack, GroupLayout.PREFERRED_SIZE, 92, GroupLayout.PREFERRED_SIZE)
				)
		);
		gl_contentPane.setVerticalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(55)
					.addComponent(heading)
					.addGap(100)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
						.addComponent(textFieldID, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE)
						.addComponent(lblIDIcon)
					)
					.addGap(110)
					.addComponent(btnDelete, GroupLayout.PREFERRED_SIZE, 37, GroupLayout.PREFERRED_SIZE)
					.addGap(50)
					.addComponent(btnBack, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE)
					.addContainerGap(78, Short.MAX_VALUE)
				)
		);
		bg.setLayout(gl_contentPane);
	}
}
