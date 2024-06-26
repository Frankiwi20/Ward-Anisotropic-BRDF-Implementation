//  Final project Group 
//  Frankie murcia
//  Juan Carlos Barraza Rivera
//  Ortasele Aisuan
//  Shunathon Owens 
//  Brenda Arellano 
surface asg3shader(
    float u_roughness = 0.25;
    float v_roughness = 0.25;
    color specularcolor = color(1, 1, 1);

)
{
    normal Nf = faceforward(normalize(N), I);
    vector V =  -normalize(I);
    normal Ln = normalize(L);

    color resultColor = 0;

    illuminance(P, Nf, PI / 2)
    {
        vector L = faceforward(normalize(L), I);  // Incoming light vector
        vector H = normalize(V + L);  // Half-vector

        vector u = normalize(Du(P));  // Tangent vector in u direction
        vector v = normalize(Dv(P));  // Tangent vector in v direction

        // Compute cosine terms for the Ward model
        float cosThetaI = Nf.normalize(L);
        float cosThetaR = Nf.normalize(V);
        float cosThetaN = Nf.normalize(H);
        float cosThetaU = u.normalize(H);
        float cosThetaV = v.normalize(H);

        // Compute the Ward BRDF term
        float exponent = -(
            (cosThetaU * cosThetaU) / (u_roughness * u_roughness) +
            (cosThetaV * cosThetaV) / (v_roughness * v_roughness)
        ) / (cosThetaN * cosThetaN);

        float wardBRDF = exp(exponent) / (4 * PI * u_roughness * v_roughness * cosThetaN);
        color brdfColor = Cl * wardBRDF * specularcolor * cosThetaI;

        resultColor += brdfColor;
    }

    Oi = Os;
    Ci = Os * resultColor;
}