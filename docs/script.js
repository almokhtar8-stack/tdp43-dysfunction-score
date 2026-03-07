// ===== Sample Data (from actual project results) =====
const sampleData = [
    {
        sample: "SRR10045016",
        condition: "KO",
        overallScore: 97.6,
        ecm: 100.0,
        inflammatory: 97.4,
        survival: 95.5
    },
    {
        sample: "SRR10045017",
        condition: "KO",
        overallScore: 97.2,
        ecm: 97.4,
        inflammatory: 95.0,
        survival: 94.8
    },
    {
        sample: "SRR10045018",
        condition: "KO",
        overallScore: 96.8,
        ecm: 99.8,
        inflammatory: 100.0,
        survival: 100.0
    },
    {
        sample: "SRR10045019",
        condition: "Rescue",
        overallScore: 1.2,
        ecm: 0.9,
        inflammatory: 0.9,
        survival: 0.0
    },
    {
        sample: "SRR10045020",
        condition: "Rescue",
        overallScore: 2.6,
        ecm: 0.1,
        inflammatory: 0.0,
        survival: 3.5
    },
    {
        sample: "SRR10045021",
        condition: "Rescue",
        overallScore: 0.8,
        ecm: 0.0,
        inflammatory: 0.9,
        survival: 5.0
    }
];

// ===== Update Score Calculator =====
function updateScore() {
    const sampleIndex = document.getElementById('sampleSelect').value;
    const sample = sampleData[sampleIndex];
    
    // Update main score
    document.getElementById('mainScore').textContent = sample.overallScore;
    document.getElementById('mainScoreBar').style.width = sample.overallScore + '%';
    
    // Update interpretation
    const interpretation = document.getElementById('interpretation');
    if (sample.overallScore < 30) {
        interpretation.textContent = 'LOW DYSFUNCTION (Rescue-like)';
        interpretation.className = 'score-interpretation interpretation-low';
    } else if (sample.overallScore < 60) {
        interpretation.textContent = 'MODERATE DYSFUNCTION';
        interpretation.className = 'score-interpretation interpretation-moderate';
    } else {
        interpretation.textContent = 'HIGH DYSFUNCTION (KO-like)';
        interpretation.className = 'score-interpretation interpretation-high';
    }
    
    // Update subscores
    document.getElementById('ecmScore').textContent = sample.ecm;
    document.getElementById('ecmBar').style.width = sample.ecm + '%';
    
    document.getElementById('inflamScore').textContent = sample.inflammatory;
    document.getElementById('inflamBar').style.width = sample.inflammatory + '%';
    
    document.getElementById('survivalScore').textContent = sample.survival;
    document.getElementById('survivalBar').style.width = sample.survival + '%';
    
    // Update treatment suggestion
    const treatment = document.getElementById('treatment');
    if (sample.overallScore > 60) {
        const suggestions = [];
        if (sample.ecm > 70) suggestions.push('MMP inhibitors (minocycline)');
        if (sample.inflammatory > 70) suggestions.push('anti-inflammatory (tocilizumab)');
        if (sample.survival > 70) suggestions.push('PI3K-Akt modulators (rapamycin)');
        
        if (suggestions.length > 0) {
            treatment.innerHTML = '<strong>Suggested Treatment:</strong> ' + suggestions.join(' + ');
        } else {
            treatment.innerHTML = '<strong>Suggested Treatment:</strong> Comprehensive multi-pathway approach recommended';
        }
    } else {
        treatment.innerHTML = '<strong>Status:</strong> Low dysfunction - monitoring recommended, no immediate treatment needed';
    }
}

// ===== Create Score Comparison Chart =====
function createScoreChart() {
    const samples = sampleData.map(s => s.sample);
    const scores = sampleData.map(s => s.overallScore);
    const colors = sampleData.map(s => s.condition === 'KO' ? '#e74c3c' : '#3498db');
    
    const trace = {
        x: samples,
        y: scores,
        type: 'bar',
        marker: {
            color: colors,
            line: {
                color: 'rgba(0,0,0,0.2)',
                width: 2
            }
        },
        text: scores.map(s => s.toFixed(1)),
        textposition: 'outside',
        hovertemplate: '<b>%{x}</b><br>Score: %{y}<extra></extra>'
    };
    
    const layout = {
        title: {
            text: 'TDP-43 Dysfunction Scores: KO vs Rescue',
            font: { size: 20, color: '#2c3e50' }
        },
        xaxis: {
            title: 'Sample',
            tickangle: -45
        },
        yaxis: {
            title: 'Dysfunction Score (0-100)',
            range: [0, 105]
        },
        plot_bgcolor: '#f8f9fa',
        paper_bgcolor: 'white',
        margin: { t: 80, b: 100, l: 60, r: 40 },
        annotations: [
            {
                x: 2.5,
                y: 50,
                xref: 'x',
                yref: 'y',
                text: 'Threshold',
                showarrow: false,
                font: { color: 'rgba(0,0,0,0.4)', size: 10 }
            }
        ],
        shapes: [
            {
                type: 'line',
                x0: -0.5,
                y0: 50,
                x1: 5.5,
                y1: 50,
                line: {
                    color: 'rgba(0,0,0,0.3)',
                    width: 2,
                    dash: 'dash'
                }
            }
        ]
    };
    
    const config = {
        responsive: true,
        displayModeBar: false
    };
    
    Plotly.newPlot('scoreChart', [trace], layout, config);
}

// ===== Create Subscore Heatmap =====
function createSubscoreChart() {
    const samples = sampleData.map(s => s.sample + ' (' + s.condition + ')');
    const pathways = ['ECM', 'Inflammatory', 'Survival'];
    
    const zData = [
        sampleData.map(s => s.ecm),
        sampleData.map(s => s.inflammatory),
        sampleData.map(s => s.survival)
    ];
    
    const trace = {
        z: zData,
        x: samples,
        y: pathways,
        type: 'heatmap',
        colorscale: [
            [0, '#3498db'],
            [0.5, '#ffffff'],
            [1, '#e74c3c']
        ],
        text: zData.map(row => row.map(val => val.toFixed(1))),
        texttemplate: '%{text}',
        textfont: {
            size: 14,
            color: 'black'
        },
        hovertemplate: '<b>%{y}</b><br>%{x}<br>Score: %{z}<extra></extra>',
        showscale: true,
        colorbar: {
            title: 'Score',
            titleside: 'right',
            tickmode: 'linear',
            tick0: 0,
            dtick: 20
        }
    };
    
    const layout = {
        title: {
            text: 'Pathway Subscores Heatmap',
            font: { size: 18, color: '#2c3e50' }
        },
        xaxis: {
            tickangle: -45,
            side: 'bottom'
        },
        yaxis: {
            autorange: 'reversed'
        },
        plot_bgcolor: 'white',
        paper_bgcolor: 'white',
        margin: { t: 60, b: 120, l: 100, r: 100 },
        height: 400
    };
    
    const config = {
        responsive: true,
        displayModeBar: false
    };
    
    Plotly.newPlot('subscoreChart', [trace], layout, config);
}

// ===== Initialize on Page Load =====
document.addEventListener('DOMContentLoaded', function() {
    // Initialize calculator with first sample
    updateScore();
    
    // Create charts
    createScoreChart();
    createSubscoreChart();
    
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            if (href !== '#') {
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    });
});

// ===== Responsive Chart Resize =====
window.addEventListener('resize', function() {
    Plotly.Plots.resize('scoreChart');
    Plotly.Plots.resize('subscoreChart');
});
