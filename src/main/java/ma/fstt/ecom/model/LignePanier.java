package ma.fstt.ecom.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ligne_panier")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class LignePanier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_ligne_panier")
    private int id_ligne_panier;

    @ManyToOne
    @JoinColumn(name = "id_panier", nullable = false)
    private Panier panier;

    @ManyToOne
    @JoinColumn(name = "id_produit", nullable = false)
    private Produit produit;

    @Column(name = "quantite", nullable = false)
    private int quantite = 1;

    @Column(name = "prix_unitaire", nullable = false)
    private double prix_unitaire;

    @Column(name = "sous_total", nullable = false)
    private double sous_total;
}