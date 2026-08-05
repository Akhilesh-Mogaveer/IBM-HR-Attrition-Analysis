import streamlit as st
import pandas as pd
import pickle
import plotly.graph_objects as go
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, 'attrition_model.pkl')

with open(MODEL_PATH, 'rb') as f:
    artifacts = pickle.load(f)

model = artifacts['model']
scaler = artifacts['scaler']
feature_columns = artifacts['feature_columns']
threshold = artifacts['threshold']
numeric_cols = artifacts['numeric_cols']

st.set_page_config(page_title="Attrition Predictor", page_icon="📊", layout="wide")


st.markdown("""
<style>
.result-card {
    padding: 24px;
    border-radius: 12px;
    border: 1px solid #1E3A5F;
}
.risk-high { background-color: #2A1418; border-color: #7A2E34; }
.risk-low { background-color: #0F2A24; border-color: #1F6F5C; }
.factor-tag {
    display: inline-block;
    padding: 4px 12px;
    margin: 4px 6px 4px 0;
    border-radius: 16px;
    font-size: 13px;
}
.tag-risk { background-color: #3A1D1F; color: #FF8080; border: 1px solid #7A2E34; }
.tag-protect { background-color: #103A30; color: #64FFDA; border: 1px solid #1F6F5C; }
</style>
""", unsafe_allow_html=True)


background_defaults = {
    'DistanceFromHome': 7, 
    'Education': 3, 
    'EducationField': 'Life Sciences',
    'PerformanceRating': 3, 
    'MonthlyRate': 14235, 
    'DailyRate': 802, 
    'HourlyRate': 66,
    'PercentSalaryHike': 14, 
    'StockOptionLevel': 1, 
    'JobInvolvement': 3,
    'JobSatisfaction': 3, 
    'EnvironmentSatisfaction': 3, 
    'RelationshipSatisfaction': 3,
    'WorkLifeBalance': 3, 
    'YearsInCurrentRole': 3, 
    'YearsWithCurrManager': 3,
    'TrainingTimesLastYear': 3,
}


st.sidebar.header("👤 Employee Profile")

st.sidebar.subheader("💼 Work Details")
overtime = st.sidebar.selectbox("OverTime", ["No", "Yes"])
business_travel = st.sidebar.selectbox("Business Travel", ["Non-Travel", "Travel_Rarely", "Travel_Frequently"])
department = st.sidebar.selectbox("Department", ["Sales", "Research & Development", "Human Resources"])
job_role = st.sidebar.selectbox("Job Role", [
    "Sales Executive", "Research Scientist", "Laboratory Technician",
    "Manufacturing Director", "Healthcare Representative", "Manager",
    "Sales Representative", "Research Director", "Human Resources"
])
job_level = st.sidebar.slider("Job Level", 1, 5, 2)

st.sidebar.subheader("📈 Experience")
age = st.sidebar.slider("Age", 18, 60, 30)
total_working_years = st.sidebar.slider("Total Working Years", 0, 40, 8)
years_at_company = st.sidebar.slider("Years At Company", 0, 40, 5)
years_since_promotion = st.sidebar.slider("Years Since Last Promotion", 0, 15, 1)
num_companies = st.sidebar.slider("Number of Companies Worked", 0, 10, 2)

st.sidebar.subheader("🧍 Personal")
marital_status = st.sidebar.selectbox("Marital Status", ["Single", "Married", "Divorced"])
gender = st.sidebar.selectbox("Gender", ["Male", "Female"])
monthly_income = st.sidebar.number_input("Monthly Income", 1000, 20000, 5000, step=500)

predict_btn = st.sidebar.button("🔮 Predict Attrition Risk", use_container_width=True)


st.title("📊 Employee Attrition Predictor")
st.markdown("Predict the likelihood of an employee leaving, based on an IBM HR dataset-trained Logistic Regression model.")
st.divider()


risk_factors_map = {
    'OverTime': ('OverTime', overtime == "Yes", "Working overtime"),
    'BusinessTravel_Travel_Frequently': ('Travel', business_travel == "Travel_Frequently", "Frequent business travel"),
    'MaritalStatus_Single': ('Marital', marital_status == "Single", "Single marital status"),
    'JobRole_Laboratory Technician': ('Role', job_role == "Laboratory Technician", "Lab Technician role"),
    'JobRole_Sales Representative': ('Role', job_role == "Sales Representative", "Sales Representative role"),
    'JobRole_Human Resources': ('Role', job_role == "Human Resources", "HR role"),
    'YearsSinceLastPromotion': ('Promotion', years_since_promotion >= 5, "No recent promotion (5+ years)"),
    'NumCompaniesWorked': ('Companies', num_companies >= 4, "High job-hopping history"),
}

protective_factors_map = {
    'TotalWorkingYears': ('Experience', total_working_years >= 15, "High total work experience"),
    'JobRole_Research Director': ('Role', job_role == "Research Director", "Stable senior role"),
    'Department_Research & Development': ('Department', department == "Research & Development", "R&D department (lower attrition rate)"),
    'BusinessTravel_Non-Travel': ('Travel', business_travel == "Non-Travel", "No business travel"),
}

if predict_btn:
    input_dict = {
        'Age': age, 'MonthlyIncome': monthly_income, 'TotalWorkingYears': total_working_years,
        'YearsAtCompany': years_at_company, 'YearsSinceLastPromotion': years_since_promotion,
        'NumCompaniesWorked': num_companies, 'JobLevel': job_level,
        'OverTime': 1 if overtime == "Yes" else 0,
        'Gender': 1 if gender == "Male" else 0,
        **background_defaults
    }
    input_df = pd.DataFrame([input_dict])

    cat_inputs = pd.DataFrame([{
        'BusinessTravel': business_travel, 'Department': department,
        'JobRole': job_role, 'MaritalStatus': marital_status,
        'EducationField': background_defaults['EducationField']
    }])
    cat_encoded = pd.get_dummies(cat_inputs)

    final_input = pd.concat([input_df.reset_index(drop=True), cat_encoded.reset_index(drop=True)], axis=1)
    final_input = final_input.reindex(columns=feature_columns, fill_value=0)
    final_input[numeric_cols] = scaler.transform(final_input[numeric_cols])

    proba = model.predict_proba(final_input)[:, 1][0]
    prediction = "Yes" if proba >= threshold else "No"

    col1, col2 = st.columns([1, 1])

    with col1:
        card_class = "risk-high" if prediction == "Yes" else "risk-low"
        icon = "⚠️" if prediction == "Yes" else "✅"
        label = "Likely to Leave" if prediction == "Yes" else "Likely to Stay"
        st.markdown(f"""
        <div class="result-card {card_class}">
            <h2>{icon} {label}</h2>
            <p style="opacity:0.7;">Prediction based on current inputs</p>
        </div>
        """, unsafe_allow_html=True)

        
        active_risk = [v[2] for v in risk_factors_map.values() if v[1]]
        active_protect = [v[2] for v in protective_factors_map.values() if v[1]]

        st.markdown("<br>", unsafe_allow_html=True)
        if active_risk:
            st.markdown("**Risk factors present:**")
            st.markdown("".join([f'<span class="factor-tag tag-risk">{f}</span>' for f in active_risk]), unsafe_allow_html=True)
        if active_protect:
            st.markdown("**Protective factors present:**")
            st.markdown("".join([f'<span class="factor-tag tag-protect">{f}</span>' for f in active_protect]), unsafe_allow_html=True)
        if not active_risk and not active_protect:
            st.markdown("*No major flagged factors from top predictors.*")

    with col2:
        if proba < 0.4:
            bar_color = "#64FFDA"   
        elif proba < 0.7:
            bar_color = "#FFC145"   # amber — medium risk
        else:
            bar_color = "#FF5C5C"   

        fig = go.Figure(go.Indicator(
            mode="gauge+number",
            value=proba * 100,
            number={'suffix': "%", 'font': {'color': '#E6F1FF'}},
            gauge={
                'axis': {'range': [0, 100], 'tickcolor': '#E6F1FF'},
                'bar': {'color': bar_color},
                'bgcolor': '#112240',
                'steps': [
                    {'range': [0, 40], 'color': '#0F2A24'},
                    {'range': [40, 70], 'color': '#3A2E14'},
                    {'range': [70, 100], 'color': '#3A1418'}
                ],
                'threshold': {'line': {'color': "#EF8F8F", 'width': 3}, 'value': threshold * 100}
            }
        ))
        fig.update_layout(
            paper_bgcolor='rgba(0,0,0,0)',
            font={'color': '#E6F1FF'},
            height=280,
            margin=dict(l=20, r=20, t=30, b=10)
        )
        st.plotly_chart(fig, use_container_width=True)

else:
    st.info("👈 Fill in the employee profile in the sidebar and click **Predict Attrition Risk**.")

st.divider()
with st.expander("ℹ️ About this model"):
    st.markdown("""
    - **Model**: Logistic Regression (class-weight balanced)  
    - **ROC-AUC**: 0.80  
    - **Decision threshold**: 0.4 (tuned for higher recall on attrition cases)  
    - **Dataset**: IBM HR Analytics Employee Attrition  
    - Built as part of an end-to-end SQL → Power BI → ML pipeline project.
    """)

st.markdown("""
<div style="text-align:center; opacity:0.5; padding-top: 30px; font-size: 13px;">
    Built by Akhilesh Mogaveer · 
    <a href="https://github.com/Akhilesh-Mogaveer" style="color:#64FFDA;">GitHub</a> · 
    <a href="https://linkedin.com/in/akhilesh-1109ma" style="color:#64FFDA;">LinkedIn</a>
</div>
""", unsafe_allow_html=True)