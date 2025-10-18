package ma.fstt.ecom.model;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "internaute")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString

public class Internaute {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "id_internaute")
        private int id_internaute;

        @Column(name = "nom", length = 100)
        private String nom;

        @Column(name = "prenom", length = 100)
        private String prenom;

        @Column(name = "email", length = 150, nullable = false, unique = true)
        private String email;

        @Column(name = "mot_de_passe", length = 255, nullable = false)
        private String mot_de_passe;

        @Column(name = "adresse", length = 255)
        private String adresse;

        @Column(name = "telephone", length = 20)
        private String telephone;
    }

