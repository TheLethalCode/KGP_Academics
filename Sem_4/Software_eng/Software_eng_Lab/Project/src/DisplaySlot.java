import javax.imageio.*;
import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;
import java.sql.*;

// Class responsible for the displaying of various slots of a sport

public class DisplaySlot extends JFrame {
	static DisplaySlot frame;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					frame = new DisplaySlot(args[0]);
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
	public DisplaySlot(String sport) {

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
		JLabel heading = new JLabel(sport + " Slots");
		heading.setForeground(new Color(210,250,210));
		heading.setFont(new Font("Tahoma", Font.BOLD, 34));
		
		/* All Labels */

		// Number 1 Label
		ImageIcon imageIcon = new ImageIcon("images/number-1.png");
		Image image = imageIcon.getImage(); // transform it into image
		Image newimg = image.getScaledInstance(33, 33,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblnumber1 = new JLabel(imageIcon); 
		
		// Number 2 Label
		imageIcon = new ImageIcon("images/number-2.png");
		image = imageIcon.getImage(); // transform it into image
		newimg = image.getScaledInstance(33, 33,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblNumber2 = new JLabel(imageIcon);

		// Number 3 Label
		imageIcon = new ImageIcon("images/number-3.png");
		image = imageIcon.getImage(); // transform it into image
		newimg = image.getScaledInstance(33, 33,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblNumber3 = new JLabel(imageIcon);

		// Number 4 Label
		imageIcon = new ImageIcon("images/number-4.png");
		image = imageIcon.getImage(); // transform it into image
		newimg = image.getScaledInstance(33, 33,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblNumber4 = new JLabel(imageIcon);

		// Number 5 Label
		imageIcon = new ImageIcon("images/number-5.png");
		image = imageIcon.getImage(); // transform it into image
		newimg = image.getScaledInstance(33, 33,  Image.SCALE_SMOOTH); // scale it the smooth way  
		imageIcon = new ImageIcon(newimg);
		JLabel lblNumber5 = new JLabel(imageIcon);
		
		/* All TextAreas */

        // For Slot 1
        JTextArea slot1 = new JTextArea();
        slot1.setEditable(false);
        slot1.setFont(new Font("Arial",Font.BOLD,30));
        slot1.setForeground(Color.black);
        slot1.setBackground(Color.green);
        slot1.setAlignmentX(Component.CENTER_ALIGNMENT);

        // For Slot 2
        JTextArea slot2 = new JTextArea();
        slot2.setEditable(false);
        slot2.setFont(new Font("Arial",Font.BOLD,30));
        slot2.setForeground(Color.black);
        slot2.setBackground(Color.green);
        slot2.setAlignmentX(Component.CENTER_ALIGNMENT);

        // For Slot 3
        JTextArea slot3 = new JTextArea();
        slot3.setEditable(false);
        slot3.setFont(new Font("Arial",Font.BOLD,30));
        slot3.setForeground(Color.black);
        slot3.setBackground(Color.green);
        slot3.setAlignmentX(Component.CENTER_ALIGNMENT);

        // For Slot 4
        JTextArea slot4 = new JTextArea();
        slot4.setEditable(false);
        slot4.setFont(new Font("Arial",Font.BOLD,30));
        slot4.setForeground(Color.black);
        slot4.setBackground(Color.green);
        slot4.setAlignmentX(Component.CENTER_ALIGNMENT);

        // For Slot 5
        JTextArea slot5 = new JTextArea();
        slot5.setEditable(false);
        slot5.setFont(new Font("Arial",Font.BOLD,30));
        slot5.setForeground(Color.black);
        slot5.setBackground(Color.green);
        slot5.setAlignmentX(Component.CENTER_ALIGNMENT);

		/* All Buttons */

		// Slot 1 Book Button
		JButton slot1Button = new JButton("Book");
		slot1Button.setBackground(new Color(9, 9, 42));
		slot1Button.setForeground(Color.WHITE);
		slot1Button.setFocusPainted(false);
		slot1Button.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener for the button
			slot1Button.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
                    PaymentPortal.main(new String[]{sport,"1"});
                    frame.dispose();
				}
            });
        
        // Slot 2 Book Button
		JButton slot2Button = new JButton("Book");
		slot2Button.setBackground(new Color(9, 9, 42));
		slot2Button.setForeground(Color.WHITE);
		slot2Button.setFocusPainted(false);
		slot2Button.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener for the button
			slot2Button.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
                    PaymentPortal.main(new String[]{sport,"2"});
                    frame.dispose();
				}
            });
        
        // Slot 3 Book Button
		JButton slot3Button = new JButton("Book");
		slot3Button.setBackground(new Color(9, 9, 42));
		slot3Button.setForeground(Color.WHITE);
		slot3Button.setFocusPainted(false);
		slot3Button.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener for the button
			slot3Button.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
                    PaymentPortal.main(new String[]{sport,"3"});
                    frame.dispose();
				}
            });
            
        // Slot 4 Book Button
		JButton slot4Button = new JButton("Book");
		slot4Button.setBackground(new Color(9, 9, 42));
		slot4Button.setForeground(Color.WHITE);
		slot4Button.setFocusPainted(false);
		slot4Button.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener for the button
			slot4Button.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
                    PaymentPortal.main(new String[]{sport,"4"});
                    frame.dispose();
				}
            });
            
        // Slot 5 Book Button
		JButton slot5Button = new JButton("Book");
		slot5Button.setBackground(new Color(9, 9, 42));
		slot5Button.setForeground(Color.WHITE);
		slot5Button.setFocusPainted(false);
        slot5Button.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener for the button
			slot5Button.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
                    PaymentPortal.main(new String[]{sport,"5"});
                    frame.dispose();
				}
			});
		
		// Getting data from the database for the slots
		int slots[] = SlotDao.check(sport);
		
		// Setting the color and enable book button appropriately
		slot1.setText(" "+slots[0]);
		if( slots[0] == 0)
		{
			slot1.setBackground(Color.RED);
			slot1Button.setEnabled(false);
		}
		else if( slots[0] < 3)
			slot1.setBackground(Color.ORANGE);

		slot2.setText(" "+slots[1]);
		if( slots[1] == 0)
		{
			slot2.setBackground(Color.RED);
			slot2Button.setEnabled(false);
		}
		else if( slots[1] < 3)
			slot2.setBackground(Color.ORANGE);

		slot3.setText(" "+slots[2]);
		if( slots[2] == 0)
		{
			slot3.setBackground(Color.RED);
			slot3Button.setEnabled(false);
		}
		else if( slots[2] < 3)
			slot3.setBackground(Color.ORANGE);

		slot4.setText(" "+slots[3]);
		if( slots[3] == 0)
		{
			slot4.setBackground(Color.RED);
			slot4Button.setEnabled(false);
		}
		else if( slots[3] < 3)
			slot4.setBackground(Color.ORANGE);

		slot5.setText(" "+slots[4]);
		if( slots[4] == 0)
		{
			slot5.setBackground(Color.RED);
			slot5Button.setEnabled(false);
		}
		else if( slots[4] < 3)
			slot5.setBackground(Color.ORANGE);
		
		// Back button
		JButton btnBack = new JButton("Back");
		btnBack.setBackground(new Color(9, 9, 9));
		btnBack.setForeground(Color.WHITE);
		btnBack.setFocusPainted(false);
		btnBack.setFont(new Font("Tahoma", Font.BOLD, 14));

			// Action Listener
			btnBack.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					int input = JOptionPane.showConfirmDialog(DisplaySlot.this, "Do you want to go back ?","Are you sure?",JOptionPane.YES_NO_OPTION);
					if( input == 0)
					{
						UserSuccess.main(new String[]{});
						frame.dispose();
					}
				}
			});

		// Layout for the background
		GroupLayout gl_contentPane = new GroupLayout(bg);

		gl_contentPane.setHorizontalGroup(
			gl_contentPane.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(110)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING, false)
						.addComponent(lblNumber2)
						.addComponent(lblnumber1)
						.addComponent(lblNumber3)
						.addComponent(lblNumber4)
						.addComponent(lblNumber5)
                    )
                    .addGap(40)
                    .addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING, false)
                        .addComponent(slot1, GroupLayout.DEFAULT_SIZE, 42, Short.MAX_VALUE)
                        .addComponent(slot2, GroupLayout.DEFAULT_SIZE, 42, Short.MAX_VALUE)
                        .addComponent(slot3, GroupLayout.DEFAULT_SIZE, 42, Short.MAX_VALUE)
                        .addComponent(slot4, GroupLayout.DEFAULT_SIZE, 42, Short.MAX_VALUE)
						.addComponent(slot5, GroupLayout.DEFAULT_SIZE, 42, Short.MAX_VALUE)
                    )
                    .addGap(70)
                    .addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING, false)
                        .addComponent(slot1Button, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
                        .addComponent(slot2Button, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
                        .addComponent(slot3Button, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
                        .addComponent(slot4Button, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
						.addComponent(slot5Button, GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
					)
					.addContainerGap(107, Short.MAX_VALUE)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addGap(120)
					.addComponent(heading)
				)
				.addGroup(gl_contentPane.createSequentialGroup()
					.addComponent(slot1Button, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE)
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
					
					.addGap(30)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.LEADING)
						.addGroup(gl_contentPane.createSequentialGroup()
							.addComponent(lblnumber1)
							.addGap(30)
							.addComponent(lblNumber2)
						)
						.addGroup(gl_contentPane.createSequentialGroup()
							.addComponent(slot1, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE)
							.addGap(30)
							.addComponent(slot2, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE)
                        )
                        .addGroup(gl_contentPane.createSequentialGroup()
							.addComponent(slot1Button, GroupLayout.PREFERRED_SIZE, 33, GroupLayout.PREFERRED_SIZE)
							.addGap(30)
							.addComponent(slot2Button, GroupLayout.PREFERRED_SIZE, 33, GroupLayout.PREFERRED_SIZE)
						)
					)
					
					.addGap(30)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblNumber3)
                        .addComponent(slot3, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE)
                        .addComponent(slot3Button, GroupLayout.PREFERRED_SIZE, 33, GroupLayout.PREFERRED_SIZE)
					)

					.addGap(30)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblNumber4)
                        .addComponent(slot4, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE)
                        .addComponent(slot4Button, GroupLayout.PREFERRED_SIZE, 33, GroupLayout.PREFERRED_SIZE)
					)

					.addGap(30)
					.addGroup(gl_contentPane.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblNumber5)
                        .addComponent(slot5, GroupLayout.PREFERRED_SIZE, 35, GroupLayout.PREFERRED_SIZE)
                        .addComponent(slot5Button, GroupLayout.PREFERRED_SIZE, 33, GroupLayout.PREFERRED_SIZE)
					)
					
					.addGap(32)
					.addComponent(btnBack, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE)
				)
		);
		bg.setLayout(gl_contentPane);
	}

}
