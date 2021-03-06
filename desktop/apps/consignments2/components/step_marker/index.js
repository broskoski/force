import PropTypes from 'prop-types'
import React from 'react'
import block from 'bem-cn'
import { connect } from 'react-redux'

function StepMarker ({ currentStep, isMobile, steps }) {
  const b = block('consignments2-step-marker')

  return (
    <div className={b({mobile: isMobile})}>
      <div className={b('steps')}>
        <ul>
          {
            steps.map((step, index) => {
              return (
                <li className={b('step', { active: index === currentStep })} key={step.label}>
                  <div className={b('label')}>
                    {isMobile ? step.shortLabel : step.label}
                  </div>
                </li>
              )
            })
          }
        </ul>
      </div>
    </div>
  )
}

const mapStateToProps = (state) => ({
  currentStep: state.submissionFlow.currentStep,
  isMobile: state.submissionFlow.isMobile,
  steps: state.submissionFlow.steps
})

export default connect(
  mapStateToProps,
)(StepMarker)

StepMarker.propTypes = {
  currentStep: PropTypes.number.isRequired,
  isMobile: PropTypes.bool.isRequired,
  steps: PropTypes.array.isRequired
}
