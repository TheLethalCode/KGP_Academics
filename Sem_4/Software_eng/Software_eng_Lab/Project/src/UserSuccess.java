import javax.imageio.*;
import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;
import javax.swing.JComboBox;

// CLass that handles the main page for the user

public class UserSuccess extends JFrame {
	static UserSuccess frame;
	private JPanel contentPane;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					frame = new UserSuccess();
					frame.setVisible(true);
				} catch (Exception e) {
					System.out.println(e);
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public UserSuccess() {

		// Sets the default close operation
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		// Sets the bounds for the GUI
		setBounds(100, 100, 500, 500);
		
		JPanel bg;
		
		// Set Background Image
        try {
            Image backgroundImage = javax.imageio.ImageIO.read(new File("images/allsports.jpg"));
            final Image bgima = backgroundImage.getScaledInstance(750, 500, Image.SCALE_DEFAULT);
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
		
		// Heading Label
		JLabel heading = new JLabel("Check Slot Availability");
		heading.setForeground(new Color(200,250,230));
		heading.setFont(new Font("Tahoma", Font.BOLD, 28));
		
		// The ComboBox of all possible sports
		String[] sports = { "--- Choose Activity ---", "Badminton" , "Gym" , "Squash" , "Table Tennis" , "Swimming", "Tennis", "BasketBall" };
		JComboBox list = new JComboBox(sports);
		list.setBackground(new Color(200,250,214));
		list.setForeground(new Color(10,0,18));
		
		// Check Slots button
		JButton slotCheck = new JButton("Check Slots");
		slotCheck.setFont(new Font("Tahoma", Font.BOLD, 15));
		slotCheck.setBackground(new Color(180,180,240));
		slotCheck.setForeground(Color.BLACK);

			// Add Action Listener
			slotCheck.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					
					// If activity is selected
					if(list.getSelectedIndex() != 0){
						DisplaySlot.main(new String[]{ list.getSelectedItem().toString()});
						frame.dispose();
					}
					else
					{
						JOptionPane.showMessageDialog(UserSuccess.this, "Please choose an activity from the drop down list","Error!", JOptionPane.ERROR_MESSAGE);
					}
				}
			});
		
		// Logout Button
		JButton btnLogout = new JButton("Logout");
		btnLogout.setFont(new Font("Tahoma", Font.BOLD, 15));
		btnLogout.setBackground(new Color(180,180,240));
		btnLogout.setForeground(Color.BLACK);

			// Action Listener
			btnLogout.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					int input = JOptionPane.showConfirmDialog(UserSuccess.this, "Do you want to really logout ?","Are you sure?",JOptionPane.YES_NO_OPTION);
					if( input == 0)
					{
						Management_System.main(new String[]{});
						frame.dispose();
					}
				}
			});

		// Horizontal and Vertical layout for the panel
		GroupLayout gl_contentPane = new GroupLayout(bg);
		gl_contentPane.setHorizontalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(70)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
						.addComponent(heading)
						.addGroup(gl_contentPane.createSequentialGroup()
							.addGap(85)
							.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
								.addComponent(list, GroupLayout.PREFERRED_SIZE, 191, GroupLayout.PREFERRED_SIZE)
								.addGroup(gl_contentPane.createSequentialGroup()
									.addGap(30)
									.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
										.addComponent(btnLogout, GroupLayout.PREFERRED_SIZE, 130, GroupLayout.PREFERRED_SIZE)
										.addComponent(slotCheck)
									)
								)
							)
						)
					)
					.addContainerGap(101, Short.MAX_VALUE)
				)
		);
		gl_contentPane.setVerticalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addContainerGap()
					.addGap(28)
					.addComponent(heading)
					.addGap(58)
					.addComponent(list,GroupLayout.PREFERRED_SIZE, 25, GroupLayout.PREFERRED_SIZE)
					.addGap(188)
					.addComponent(slotCheck, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE)
					.addGap(18)
					.addComponent(btnLogout, GroupLayout.PREFERRED_SIZE, 34, GroupLayout.PREFERRED_SIZE)
				)
		);
		bg.setLayout(gl_contentPane);
	}

}
